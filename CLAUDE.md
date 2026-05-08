# CLAUDE.md — 個人ブログ プロジェクト仕様

## プロジェクト概要

個人の学習・アウトプット用ブログアプリ。
自分だけが使う想定。Markdownで記事を書き、公開/非公開を記事ごとに切り替えられる。

---

## 技術スタック

| 項目 | 内容 |
|------|------|
| Ruby | 最新安定版 |
| Rails | 最新安定版（Rails 8系） |
| DB | SQLite3 |
| 認証 | has_secure_password + 自前セッション管理 |
| Markdown描画 | redcarpet + rouge |
| インフラ | AWS EC2 t4g.nano + Route 53 + ACM |
| 開発環境 | Docker（docker-compose） |

---

## モデル設計

### User

```ruby
# 1ユーザーのみ想定
# db/seeds.rb で初期ユーザーを作成する運用
create_table :users do |t|
  t.string :email, null: false
  t.string :password_digest, null: false
  t.timestamps
end
```

### Post

```ruby
create_table :posts do |t|
  t.string  :title,     null: false
  t.text    :body,      null: false  # Markdown形式
  t.boolean :published, null: false, default: false
  t.timestamps
end
```

---

## ルーティング

```ruby
Rails.application.routes.draw do
  # 公開側
  root "posts#index"
  resources :posts, only: [:show]

  # 管理側
  namespace :admin do
    resources :posts, only: [:new, :create, :edit, :update, :destroy]
  end

  # 認証
  get  "/login",  to: "sessions#new"
  post "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
```

---

## 認証

- `has_secure_password`（bcrypt gem）を使用
- `SessionsController` でセッション管理
- `current_user` / `logged_in?` ヘルパーを `ApplicationController` に定義
- 管理側は `before_action :require_login` で保護

```ruby
# app/controllers/application_controller.rb
def current_user
  @current_user ||= User.find_by(id: session[:user_id])
end

def logged_in?
  !!current_user
end

def require_login
  redirect_to login_path unless logged_in?
end
```

---

## Markdown描画

```ruby
# Gemfile
gem "redcarpet"
gem "rouge"
```

```ruby
# app/helpers/application_helper.rb
def markdown(text)
  renderer = Redcarpet::Render::HTML.new(
    hard_wrap: true,
    with_toc_data: false
  )
  options = {
    autolink: true,
    fenced_code_blocks: true,
    tables: true,
    strikethrough: true
  }
  Redcarpet::Markdown.new(renderer, options).render(text).html_safe
end
```

---

## 画面一覧

| 画面 | パス | コントローラ | 認証必要 |
|------|------|-------------|---------|
| 記事一覧（公開） | `/` | Posts#index | 不要 |
| 記事詳細（公開） | `/posts/:id` | Posts#show | 不要（公開記事のみ） |
| 記事作成 | `/admin/posts/new` | Admin::Posts#new | 必要 |
| 記事編集 | `/admin/posts/:id/edit` | Admin::Posts#edit | 必要 |
| ログイン | `/login` | Sessions#new | — |

### 補足
- 非公開記事はログイン中のみ `/posts/:id` で閲覧可能
- 公開側の記事一覧 `/` はログイン中なら非公開記事も表示する

---

## Docker構成

```
blog/
├── docker-compose.yml
├── Dockerfile
├── .env.example
└── ...
```

```yaml
# docker-compose.yml（最小構成）
services:
  web:
    build: .
    command: bundle exec rails s -b '0.0.0.0'
    volumes:
      - .:/app
      - bundle_cache:/usr/local/bundle
    ports:
      - "3000:3000"
    environment:
      - RAILS_ENV=development

volumes:
  bundle_cache:
```

---

## 命名規則・方針

- コントローラは `Admin::PostsController` と `PostsController` で分離
- ビューは `app/views/admin/posts/` と `app/views/posts/` で分離
- Helperは `ApplicationHelper` に共通処理を集約
- テストは1stリリースでは省略可（スコープ外）
- シードで初期ユーザーを作成する（ユーザー登録画面は作らない）

---

## 環境変数

```bash
# .env.example
SECRET_KEY_BASE=your_secret_key_base
BLOG_ADMIN_EMAIL=your@email.com
BLOG_ADMIN_PASSWORD=your_password
```

---

## やらないこと（1stリリーススコープ外）

- 画像アップロード
- タグ・カテゴリ
- コメント機能
- 検索機能
- RSS
- OGP
- ユーザー登録画面（seed運用）
- テスト自動化
