import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as lambda_nodejs from 'aws-cdk-lib/aws-lambda-nodejs';
import * as ssm from 'aws-cdk-lib/aws-ssm';
import * as iam from 'aws-cdk-lib/aws-iam';

export class EdgeLambdaStack extends cdk.Stack {
    constructor(scope: Construct, id: string, props?: cdk.StackProps) {
        super(scope, id, props);

        // https://qiita.com/k_bobchin/items/1067cc0949a9de3e5c5b
        const role = new iam.Role(this, "LambdaEdgeExecutionRole", {
            assumedBy: new iam.CompositePrincipal(
                new iam.ServicePrincipal("lambda.amazonaws.com"),
                new iam.ServicePrincipal("edgelambda.amazonaws.com") // デフォルトで生成されるロールはこれがないので追加
            ),
            managedPolicies: [iam.ManagedPolicy.fromAwsManagedPolicyName("service-role/AWSLambdaBasicExecutionRole")],
        });
        const addForwardedHostFunction = new lambda_nodejs.NodejsFunction(this, 'AddForwardedHostFunction', {
            entry: 'src/lambda/add_forwarded_host/index.js',
            awsSdkConnectionReuse: false,   // https://github.com/aws/aws-cdk/issues/9328
            bundling: {
                forceDockerBundling: false,
            },
            role
        });
        new ssm.StringParameter(this, 'AddForwardedHostFunctionArn', {
            dataType: ssm.ParameterDataType.TEXT,
            description: 'AddForwardedHostFunctionArn',
            parameterName: '/rails-takeyuwebinc/add_forwarded_host_function_arn',
            stringValue: addForwardedHostFunction.currentVersion.functionArn,
        });
    }
}
