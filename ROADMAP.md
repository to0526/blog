# 実装ロードマップ & 追加機能候補

---

## 実装ロードマップ

### Phase 0: 開発環境構築

- [x] Railsプロジェクト新規作成
- [x] Dockerfile / docker-compose.yml 作成
- [x] SQLite3 設定確認（database.yml）
- [ ] `bin/setup` で起動確認

### Phase 1: モデル・認証

- [x] `User` モデル作成（has_secure_password）
- [x] `Post` モデル作成
- [x] `db/seeds.rb` で初期ユーザー作成
- [x] `SessionsController` 作成（ログイン・ログアウト）
- [x] `ApplicationController` に `current_user` / `require_login` 追加

### Phase 2: 管理側（記事CRUD）

- [x] `Admin::PostsController` 作成（new / create / edit / update / destroy）
- [x] 管理側ビュー作成（new.html.erb / edit.html.erb）
- [x] Markdownエディタ（textarea）実装
- [x] 公開/非公開の切り替えUI

### Phase 3: 公開側

- [x] `PostsController` 作成（index / show）
- [x] 記事一覧ビュー（公開記事のみ表示）
- [x] 記事詳細ビュー（Markdownをレンダリング）
- [x] `redcarpet` + `rouge` セットアップ

### Phase 4: スタイリング

- [x] CSSフレームワーク or 素のCSS でベーススタイル適用
- [x] コードブロックのシンタックスハイライト確認

### Phase 5: AWS デプロイ

- [ ] EC2 t4g.nano インスタンス起動（Amazon Linux 2023）
- [ ] Ruby / Rails 環境構築（rbenv or Docker on EC2）
- [ ] Nginx + Puma 設定
- [ ] SQLiteデータベースファイルのパス設定
- [ ] Route 53 ドメイン取得・設定
- [ ] ACM 証明書発行
- [ ] ALB or Nginx でHTTPS終端
- [ ] 本番環境変数設定（SECRET_KEY_BASE 等）
- [ ] デプロイスクリプト作成（capistrano or シェルスクリプト）

---

## 追加機能候補（2nd リリース以降）

### 優先度：高（すぐ欲しくなりそう）

| 機能 | 概要 |
|------|------|
| 画像アップロード | S3 + ActiveStorage。記事に画像を貼れるようにする |
| タグ | 記事に複数タグを付けて絞り込みできるようにする |
| 管理：記事一覧 | 投稿数が増えてきたら必要。published状態も一覧で確認できると便利 |
| Markdownプレビュー | 編集画面で書きながらプレビューを確認できるようにする（Stimulus.js等） |

### 優先度：中（あると便利）

| 機能 | 概要 |
|------|------|
| 検索 | タイトル・本文の全文検索（SQLiteのFTS5が使える） |
| OGP設定 | SNSシェア時にタイトル・説明が表示されるようにする |
| RSS | フィードを公開して購読できるようにする |
| シンタックステーマ選択 | rougeのテーマをconfigで切り替えられるようにする |
| 下書き一覧 | 非公開記事だけ表示するフィルター |

### 優先度：低（将来的に）

| 機能 | 概要 |
|------|------|
| カテゴリ | タグより大きな分類。タグが増えてきたら検討 |
| 目次の自動生成 | 長い記事用。redcarpetのwith_toc_dataを活用 |
| アクセス解析 | Google Analytics or privacy-friendlyな代替（Plausible等） |
| 記事のエクスポート | Markdown形式でダウンロードできるようにする |
| CI/CD | GitHub ActionsでEC2へ自動デプロイ |

---

## デプロイ方法の選択肢（Phase 5 詳細）

### オプションA：Dockerのままデプロイ
EC2上でもdocker-composeで動かす。開発と本番の差異が少なく管理しやすい。

### オプションB：直接デプロイ（rbenv + Puma + Nginx）
EC2にRubyを直接インストール。Dockerなし。シンプルで軽い。

**おすすめはオプションA**（Docker環境をそのまま活かせる）。
ただしt4g.nanoはメモリ512MBなのでswap設定を忘れずに。
