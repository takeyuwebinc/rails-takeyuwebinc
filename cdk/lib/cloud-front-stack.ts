import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as ssm from 'aws-cdk-lib/aws-ssm';
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront';
import * as cloudfront_origins from 'aws-cdk-lib/aws-cloudfront-origins';
import * as acm from 'aws-cdk-lib/aws-certificatemanager';
import * as route53 from 'aws-cdk-lib/aws-route53';
import * as route53_targets from 'aws-cdk-lib/aws-route53-targets';
import { SsmParameterReader } from './ssm-parameter-reader';

export class CloudFrontStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // CloudFront Distributionを作成する
    // カスタムオリジンは パラメータストアから取得する（パラメータ名 /rails-takeyuwebinc/origin）
    // オリジンに指定するTailscale Funnelのホスト名をオリジンリクエストに使用するようにするため、
    // オリジンリクエストポリシーでは Hostへのヘッダーを含めないように注意
    // Funnelのルーティングにホスト名を使用する（SNI）のため。
    // https://github.com/tailscale/tailscale/issues/7758#issuecomment-1493649153
    const origin = ssm.StringParameter.valueForStringParameter(this, '/rails-takeyuwebinc/origin');
    const httpOrigin = new cloudfront_origins.HttpOrigin(origin, {
      protocolPolicy: cloudfront.OriginProtocolPolicy.HTTP_ONLY,
      httpPort: 8080,
    });
    const publicHostedZone = route53.PublicHostedZone.fromLookup(
      this,
      "PublicHostedZone",
      {
        domainName: "takeyuweb.co.jp",
      }
    );
    const certificateArnReader = new SsmParameterReader(this, 'CertificateArnParameter', {
      parameterName: '/rails-takeyuwebinc/certificate_arn',
      region: 'us-east-1',
    });
    const certificate = acm.Certificate.fromCertificateArn(this, 'Certificate', certificateArnReader.getParameterValue());
    const staticOriginRequestPolicy = new cloudfront.OriginRequestPolicy(this, 'StaticOriginRequestPolicy', {
      queryStringBehavior: cloudfront.OriginRequestQueryStringBehavior.none(),
      headerBehavior: cloudfront.OriginRequestHeaderBehavior.allowList('origin', 'host'),
      cookieBehavior: cloudfront.OriginRequestCookieBehavior.none(),
      comment: 'Allow origin header',
    });
    const distribution = new cloudfront.Distribution(this, 'Distribution', {
      domainNames: ['takeyuweb.co.jp', 'www.takeyuweb.co.jp'],
      certificate: certificate,
      comment: 'takeyuweb.co.jp',
      defaultBehavior: {
        origin: httpOrigin,
        allowedMethods: cloudfront.AllowedMethods.ALLOW_ALL,
        cachedMethods: cloudfront.CachedMethods.CACHE_GET_HEAD,
        cachePolicy: new cloudfront.CachePolicy(this, 'AppCachePolicy', {
          minTtl: cdk.Duration.seconds(2),
          maxTtl: cdk.Duration.seconds(600),
          defaultTtl: cdk.Duration.seconds(2),
          cookieBehavior: cloudfront.CacheCookieBehavior.all(),
          headerBehavior: cloudfront.CacheHeaderBehavior.allowList('Authorization', 'host'),
          queryStringBehavior: cloudfront.CacheQueryStringBehavior.all(),
          enableAcceptEncodingBrotli: true,
          enableAcceptEncodingGzip: true,
        }),
        viewerProtocolPolicy: cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
        originRequestPolicy: cloudfront.OriginRequestPolicy.ALL_VIEWER,
        functionAssociations: [],
      },
      additionalBehaviors: {
        '/assets/*': {
          origin: httpOrigin,
          allowedMethods: cloudfront.AllowedMethods.ALLOW_GET_HEAD_OPTIONS,
          cachedMethods: cloudfront.CachedMethods.CACHE_GET_HEAD,
          viewerProtocolPolicy: cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
          cachePolicy: new cloudfront.CachePolicy(this, 'AssetsCachePolicy', {
            minTtl: cdk.Duration.seconds(1),
            maxTtl: cdk.Duration.seconds(31536000),
            defaultTtl: cdk.Duration.seconds(86400),
            cookieBehavior: cloudfront.CacheCookieBehavior.none(),
            headerBehavior: cloudfront.CacheHeaderBehavior.allowList('viewer-host'),
            queryStringBehavior: cloudfront.CacheQueryStringBehavior.none(),
            enableAcceptEncodingBrotli: true,
            enableAcceptEncodingGzip: true,
          }),
          originRequestPolicy: staticOriginRequestPolicy,
          functionAssociations: [],
        },
        '/rails/active_storage/disk/*': {
          origin: httpOrigin,
          allowedMethods: cloudfront.AllowedMethods.ALLOW_GET_HEAD_OPTIONS,
          cachedMethods: cloudfront.CachedMethods.CACHE_GET_HEAD,
          viewerProtocolPolicy: cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
          cachePolicy: new cloudfront.CachePolicy(this, 'StorageCachePolicy', {
            minTtl: cdk.Duration.seconds(1),
            maxTtl: cdk.Duration.seconds(31536000),
            defaultTtl: cdk.Duration.seconds(86400),
            cookieBehavior: cloudfront.CacheCookieBehavior.none(),
            headerBehavior: cloudfront.CacheHeaderBehavior.allowList('viewer-host'),
            queryStringBehavior: cloudfront.CacheQueryStringBehavior.none(),
            enableAcceptEncodingBrotli: false,
            enableAcceptEncodingGzip: false,
          }),
          originRequestPolicy: staticOriginRequestPolicy,
          functionAssociations: [],
        },
      },
      minimumProtocolVersion: cloudfront.SecurityPolicyProtocol.TLS_V1_2_2021,
      priceClass: cloudfront.PriceClass.PRICE_CLASS_200,
    });
    new route53.ARecord(this, 'ARecord', {
      zone: publicHostedZone,
      target: route53.RecordTarget.fromAlias(new route53_targets.CloudFrontTarget(distribution)),
      recordName: 'takeyuweb.co.jp',
    });
    new route53.CnameRecord(this, 'CnameRecord', {
      zone: publicHostedZone,
      domainName: 'takeyuweb.co.jp.',
      recordName: 'www',
      ttl: cdk.Duration.minutes(5),
    });
  }
}
