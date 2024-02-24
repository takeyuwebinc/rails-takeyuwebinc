import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as route53 from 'aws-cdk-lib/aws-route53';
import * as ses from 'aws-cdk-lib/aws-ses';
import * as iam from 'aws-cdk-lib/aws-iam';

export class SesStack extends cdk.Stack {
    constructor(scope: Construct, id: string, props?: cdk.StackProps) {
        super(scope, id, props);
        const publicHostedZone = route53.PublicHostedZone.fromLookup(
            this,
            "PublicHostedZone",
            {
                domainName: "takeyuweb.co.jp",
            }
        );
        const mailHostedZone = new route53.PublicHostedZone(this, 'MailHostedZone', {
            zoneName: 'mail.takeyuweb.co.jp',
        });
        new route53.NsRecord(this, 'MailDomainNsRecord', {
            zone: publicHostedZone,
            recordName: 'mail.takeyuweb.co.jp',
            values: mailHostedZone.hostedZoneNameServers as string[],
        });

        const identity = new ses.EmailIdentity(this, 'Identity', {
            identity: ses.Identity.publicHostedZone(mailHostedZone),
        });

        new route53.TxtRecord(this, 'DmarcRecord', {
            zone: mailHostedZone,
            recordName: '_dmarc.mail.takeyuweb.co.jp',
            values: [
                '"v=DMARC1; p=none; rua=mailto:hostmaster+dmarc.rua@takeyuweb.co.jp; ruf=mailto:hostmaster+dmarc.ruf@takeyuweb.co.jp; aspf=r;"'
            ]
        });

        const sesUser = new iam.User(this, 'SesUser', {
            userName: 'ses-user',
        });
        sesUser.addToPolicy(
            new iam.PolicyStatement({
                actions: [
                    'ses:SendEmail',
                    'ses:SendRawEmail',
                ],
                resources: [identity.emailIdentityArn],
            }),
        );

        const key = new iam.CfnAccessKey(this, 'SesUserKey', {
            userName: sesUser.userName,
        });
        new cdk.CfnOutput(this, 'SesUserAccessKey', { value: key.ref });
        new cdk.CfnOutput(this, 'SesUserSecretAccessKey', {
            value: key.attrSecretAccessKey,
        });
    }
}
