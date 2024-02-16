import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as ssm from 'aws-cdk-lib/aws-ssm';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront';
import * as cloudfront_origins from 'aws-cdk-lib/aws-cloudfront-origins';
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
    const addForwardedHostFunctionArnReader = new SsmParameterReader(this, 'AddForwardedHostFunctionArnReader', {
      parameterName: '/rails-takeyuwebinc/add_forwarded_host_function_arn',
      region: 'us-east-1'
    });
    const addForwardedHostFunctionArn = addForwardedHostFunctionArnReader.getParameterValue();
    const distribution = new cloudfront.Distribution(this, 'Distribution', {
      comment: 'takeyuweb.co.jp',
      defaultBehavior: {
        allowedMethods: cloudfront.AllowedMethods.ALLOW_ALL,
        cachedMethods: cloudfront.CachedMethods.CACHE_GET_HEAD,
        cachePolicy: cloudfront.CachePolicy.CACHING_DISABLED,
        viewerProtocolPolicy: cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
        originRequestPolicy: cloudfront.OriginRequestPolicy.ALL_VIEWER_EXCEPT_HOST_HEADER,
        edgeLambdas: [
          {
            eventType: cloudfront.LambdaEdgeEventType.ORIGIN_REQUEST,
            functionVersion: lambda.Version.fromVersionArn(this, 'EdgeLambdaFunctionArn', addForwardedHostFunctionArn),
          }
        ],
        origin: new cloudfront_origins.HttpOrigin(origin),
      },
      minimumProtocolVersion: cloudfront.SecurityPolicyProtocol.TLS_V1_2_2021,
      priceClass: cloudfront.PriceClass.PRICE_CLASS_200,
    });
  }
}
