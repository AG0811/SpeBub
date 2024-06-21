# プロジェクト名

Rails 7.0 を使用したニュース共有アプリケーションです。

## 概要

このアプリケーションでは、ユーザーがニュースを投稿し、他のユーザーがそれを読んだり、お気に入りに追加したり、コメントを残したりすることができます。

## モデル

### User

- `username`: ユーザー名
- `address_id`: 住所 ID
- `ip_address`: IP アドレス

### News

- `user_id`: ユーザー ID
- `author_name`: 投稿者名
- `title`: タイトル
- `content`: コンテンツ
- `category_id`: カテゴリ ID
- `prefecture_id`: 都道府県 ID

### Favorite

- `user_id`: ユーザー ID
- `news_id`: ニュース ID

### ReadStatus

- `user_id`: ユーザー ID
- `news_id`: ニュース ID
- `read`: 読んだかどうか

### Comment

- `user_id`: ユーザー ID
- `news_id`: ニュース ID
- `text`: コメントテキスト

## セットアップ

以下のコマンドで環境をセットアップします。

```bash
bundle install
rails db:create
rails db:migrate
```
