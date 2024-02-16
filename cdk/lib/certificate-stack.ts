import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as ssm from 'aws-cdk-lib/aws-ssm';
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront';
import * as cloudfront_origins from 'aws-cdk-lib/aws-cloudfront-origins';
import * as acm from 'aws-cdk-lib/aws-certificatemanager';
import * as route53 from 'aws-cdk-lib/aws-route53';
import * as route53_targets from 'aws-cdk-lib/aws-route53-targets';

export class CertificateStack extends cdk.Stack {
    constructor(scope: Construct, id: string, props?: cdk.StackProps) {
        super(scope, id, props);

        const publicHostedZone = route53.PublicHostedZone.fromLookup(
            this,
            "PublicHostedZone",
            {
                domainName: "takeyuweb.co.jp",
            }
        );
        const certificate = new acm.Certificate(this, "Certificate", {
            domainName: "takeyuweb.co.jp",
            subjectAlternativeNames: ["*.takeyuweb.co.jp"],
            validation: acm.CertificateValidation.fromDns(publicHostedZone),
        });
        new route53.CaaRecord(this, 'CaaRecord', {
            zone: publicHostedZone,
            values: [
                {
                    flag: 0,
                    tag: route53.CaaTag.ISSUE,
                    value: "amazontrust.com"
                },
                {
                    flag: 0,
                    tag: route53.CaaTag.ISSUEWILD,
                    value: "amazontrust.com"
                }
            ]
        });

        new ssm.StringParameter(this, 'CertificateArnParameter', {
            dataType: ssm.ParameterDataType.TEXT,
            description: 'Certifcate ARN for CloudFront',
            parameterName: '/rails-takeyuwebinc/certificate_arn',
            stringValue: certificate.certificateArn,
        });
    }
}
