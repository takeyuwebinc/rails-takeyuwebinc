import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as ssm from 'aws-cdk-lib/aws-ssm';
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront';
import * as cloudfront_origins from 'aws-cdk-lib/aws-cloudfront-origins';

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
    const viewerHostFunction = new cloudfront.Function(this, 'ViewerHostFunction', {
      code: cloudfront.FunctionCode.fromFile({
        filePath: 'src/lambda/viewer_host/index.js',
      }),
      runtime: cloudfront.FunctionRuntime.JS_2_0,
    });
    const distribution = new cloudfront.Distribution(this, 'Distribution', {
      comment: 'takeyuweb.co.jp',
      defaultBehavior: {
        origin: new cloudfront_origins.HttpOrigin(origin),
        allowedMethods: cloudfront.AllowedMethods.ALLOW_ALL,
        cachedMethods: cloudfront.CachedMethods.CACHE_GET_HEAD,
        cachePolicy: new cloudfront.CachePolicy(this, 'AppCachePolicy', {
          minTtl: cdk.Duration.seconds(2),
          maxTtl: cdk.Duration.seconds(600),
          defaultTtl: cdk.Duration.seconds(2),
          cookieBehavior: cloudfront.CacheCookieBehavior.all(),
          headerBehavior: cloudfront.CacheHeaderBehavior.allowList('Authorization'),
          queryStringBehavior: cloudfront.CacheQueryStringBehavior.all(),
          enableAcceptEncodingBrotli: true,
          enableAcceptEncodingGzip: true,
        }),
        viewerProtocolPolicy: cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
        originRequestPolicy: cloudfront.OriginRequestPolicy.ALL_VIEWER_EXCEPT_HOST_HEADER,
        functionAssociations: [
          {
            function: viewerHostFunction,
            eventType: cloudfront.FunctionEventType.VIEWER_REQUEST,
          }
        ],
      },
      additionalBehaviors: {
        '/assets/*': {
          origin: new cloudfront_origins.HttpOrigin(origin),
          allowedMethods: cloudfront.AllowedMethods.ALLOW_GET_HEAD_OPTIONS,
          cachedMethods: cloudfront.CachedMethods.CACHE_GET_HEAD,
          viewerProtocolPolicy: cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
          cachePolicy: cloudfront.CachePolicy.CACHING_OPTIMIZED,
          originRequestPolicy: cloudfront.OriginRequestPolicy.CORS_CUSTOM_ORIGIN,
          functionAssociations: [
            {
              function: viewerHostFunction,
              eventType: cloudfront.FunctionEventType.VIEWER_REQUEST,
            }
          ],
        },
      },
      minimumProtocolVersion: cloudfront.SecurityPolicyProtocol.TLS_V1_2_2021,
      priceClass: cloudfront.PriceClass.PRICE_CLASS_200,
    });
  }
}
