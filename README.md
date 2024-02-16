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
