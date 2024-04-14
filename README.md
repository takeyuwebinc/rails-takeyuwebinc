# rails-takeyuwebinc

タケユー・ウェブ株式会社のあれこれ
コーポレートサイト、ブログ等に活用し、実験場として育てていきたい

## Tailscaleの設定
1. Serverにインストール
  - [Tailscale SSH](https://tailscale.com/kb/1193/tailscale-ssh)
2. MagicDNS でSSH接続できることを確認
  - `ssh ubuntu@app`

## deploy

### Server
```bash
$ sudo su -
$ mkdir -p /srv/kamal/rails-takeyuwebinc-storage
$ chown 1000:1000 /srv/kamal/rails-takeyuwebinc-storage
```

### DevContainer
```
$ gem install kamal
$ bin/kamal deploy -d production
```

## AWS
```
$ cd cdk
$ yarn
$ yarn cdk bootstrap
```

### SES
```
$ yarn cdk deploy SesStack
```

AWSのアクセスキーとシークレットが表示されるので控えて

```
$ bin/rails credentials:edit --environment production
```

```
aws:
  access_key_id: AKIXXXXXXXXXXXXXXXX
  secret_access_key: xxxxxxxxxxxxxxxxxxxxxxxxxx
```

なお、[SMTP用のキーはこれとは別でcdkでは作成するのが面倒](https://stackoverflow.com/questions/69736117/how-can-i-generate-aws-ses-smtp-credentials-using-the-cdk)なので AWS SDK を使用。

### CloudFront による公開

```
$ aws configure
```

CloudFrontのオリジンを Parameter に入れておく

```
$ aws ssm put-parameter --name "/rails-takeyuwebinc/origin" --type "String" --value "XXX.XXX.XXX.XXX" --overwrite
```

CDK実行

```
$ yarn cdk deploy CertificateStack
$ yarn cdk deploy CloudFrontStack
```
