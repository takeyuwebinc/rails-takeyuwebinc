#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { EdgeLambdaStack } from '../lib/edge-lambda-stack';
import { CloudFrontStack } from '../lib/cloud-front-stack';

const app = new cdk.App();
new EdgeLambdaStack(app, 'EdgeLambdaStack', {
  env: { account: process.env.CDK_DEFAULT_ACCOUNT, region: 'us-east-1' },
});
new CloudFrontStack(app, 'CloudFrontStack', {
  env: { account: process.env.CDK_DEFAULT_ACCOUNT, region: process.env.CDK_DEFAULT_REGION },
});

app.synth();
