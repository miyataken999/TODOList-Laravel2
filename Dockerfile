FROM php:8.2-cli

# 1) 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libsqlite3-dev \
    wget \
    libicu-dev \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install \
    pdo_mysql \
    mbstring \
    zip \
    && docker-php-ext-install pdo pdo_sqlite

# 2) Composer のインストール
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

# 3) Git 設定を --system で実施（グローバルは不可）
RUN git config --system user.email "kenken999@users.noreply.huggingface.co" \
 && git config --system user.name "Ken Ken"

# 4) 作業ディレクトリを設定
WORKDIR /app

# 5) Laravel プロジェクトをコピー
COPY . /app

# 6) .env.example を .env にコピー
RUN cp .env.example .env

# 7) SQLite 用に環境変数を書き換えたい場合は以下を有効化
# RUN sed -i "s/DB_CONNECTION=.*/DB_CONNECTION=sqlite/" .env \
#     && sed -i "s|DB_DATABASE=.*|DB_DATABASE=/app/database/database.sqlite|" .env

# 8) Composer で依存関係をインストール
RUN composer install

# 9) Laravel アプリキーを生成
RUN php artisan key:generate

# 10) SQLite データベースファイルと書き込み権限の準備
RUN mkdir -p database \
 && touch database/database.sqlite \
 && chmod -R 777 database storage bootstrap/cache

# 11) マイグレーション（開発用・失敗しても続行）
RUN php artisan migrate --force || true

# 12) ポート公開と起動コマンド
EXPOSE 8000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
