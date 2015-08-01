# sugamasao.com 構築メモ

## 前提条件

- ConohaのVPS(Ubuntu)が構築済みであること
- Conohaのrootユーザに予めsshの公開鍵が登録済み
- ローカル環境にRuby 2.2系がインストールされていること
    - ほかは試してないからわからないけど、2.0以降なら動きそうな気はする
    - gem で Bundler がインストールされてること

`git clone` したら以下で各種ライブラリのインストールを行う（オプションはおこのみで）

```
$ bundle install --path vendor/bundle --jobs 4
```

ConohaのVPSはrootユーザしかいないため、 `~/.ssh/config` に対象サーバのIPアドレスとrootユーザを記載し、rootユーザでsshログインできるようにしておくこと

```
Host host_name
  User root
  HostName xxx.xxx.xxx.xxx
  IdentityFile ~/.ssh/xxx.pem
```

## サーバに一般ユーザを作成する

rootユーザで作業するのはダルいので、一般ユーザを作成する

```sh
$ bundle exec itamae ssh -h host_name --node-json=config/user.json bootstrap.rb
```

途中で作成する一般ユーザのパスワードを入力させるので、そこで入力する必要がある

設定が終わったら、一般ユーザでsshログインできるようにしておくため、`~/.ssh/config` の設定を一般ユーザに変更しておく。

```
Host host_name
  User sugamasao
  HostName xxx.xxx.xxx.xxx
  IdentityFile ~/.ssh/xxx.pem
```

念のためこの設定でsshでログインできることを確認しておくこと

## 各種設定をする

### sshやホスト名の設定

sshの設定を変更する際、rootログインをOFFにするため一般ユーザでログインできないと詰む

```sh
$ bundle exec itamae ssh -h host_name --node-json=config/base.json bootstrap.rb
```

### nginxの設定

nginxは単にリダイレクトさせるだけ

```sh
$ bundle exec itamae ssh -h host_name --node-json=config/web.json bootstrap.rb
```

### 監視の設定

https://mackerel.io/ にアカウントとAPI Keyがあること

```sh
$ bundle exec itamae ssh -h host_name --node-json=config/mackerel.json bootstrap.rb
```

途中でAPI Keyを入力するプロンプトが表示されるので、そこで入力する
