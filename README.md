# rails-takeyuwebinc

タケユー・ウェブ株式会社のあれこれ
コーポレートサイト、ブログ等に活用し、実験場として育てていきたい

## Tailscaleの設定
1. Serverにインストール
  - [Tailscale SSH](https://tailscale.com/kb/1193/tailscale-ssh)
2. [公式ガイドに従ってコンテナ側の設定](https://tailscale.com/blog/docker-tailscale-guide)
  - [AuthKeyの取得](https://login.tailscale.com/admin/settings/keys)
    - Reusable: yes
    - tags: `rails-takeyuwebinc-devcontainer` を設定する
  - [ACL (tagOwners)の設定](https://login.tailscale.com/admin/acls/file)
    ```json
    "tagOwners": {
	    "tag:rails-takeyuwebinc-devcontainer": ["autogroup:admin"],
    },
    ```

## DevContainer
```bash
$ cp .devcontainer/.env.tailscale-app.sample .devcontainer/.env.tailscale-app
$ vim .devcontainer/.env.tailscale-app
TS_AUTHKEY=TailscaleのAuthKey
$ Code .
```

コンテナーで再度開く

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
$ kamal deploy
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
