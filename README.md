# rails-takeyuwebinc

タケユー・ウェブ株式会社のあれこれ
コーポレートサイト、ブログ等に活用し、実験場として育てていきたい

## Tailscaleの設定
1. Serverにインストール
  - [Tailscale SSH](https://tailscale.com/kb/1193/tailscale-ssh)
2. [公式ガイドに従ってコンテナ側の設定](https://tailscale.com/blog/docker-tailscale-guide)
  - [AuthKeyの取得](https://login.tailscale.com/admin/settings/keys)
  - [ACL (tagOwners)の設定](https://login.tailscale.com/admin/acls/file)
    ```json
    "tagOwners": {
	    "tag:container": ["autogroup:admin"],
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

## Tailscale Funnel + CloudFront による公開
### Tailscale Funnel
1. ACL

```
  "groups": {
    "group:funnel":  ["xxxxxxxxxxxxxx@takeyuweb.co.jp"],
  },
  "nodeAttrs": [
    {
      "target": ["group:funnel"],
      "attr":   ["funnel"],
    },
  ],
```

2. Server で Funnel を有効にする

```
$ tailscale funnel --bg http://127.0.0.1:80

Available on the internet: 
https://xxxxxxx.xxxxxxxx.ts.net/
|-- proxy http://127.0.0.1:80
```

### AWS

```
$ aws configure
```

CloudFrontのオリジンを Parameter に入れておく

```
$ aws ssm put-parameter --name "/rails-takeyuwebinc/origin" --type "String" --value "xxxxxxx.xxxxxxxx.ts.net" --overwrite
```

CDK実行

```
$ cd cdk
$ yarn
$ yarn cdk bootstrap
$ yarn cdk deploy
```
