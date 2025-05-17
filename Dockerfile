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

# 3) Git ユーザー設定（グローバルは禁止。systemのみ許可される）
RUN git config --system user.email "kenken999@users.noreply.huggingface.co" \
 && git config --system user.name "Ken Ken"

# 4) 作業ディレクトリを設定
WORKDIR /app

# 5) Laravel プロジェクトをコピー
COPY . /app

# 6) .env 設定（必要に応じて SQLite に修正）
RUN cp .env.example .env

# SQLite 用に書き換えたい場合はこのコメントアウトを外す
# RUN sed -i "s/DB_CONNECTION=.*/DB_CONNECTION=sqlite/" .env \
#     && sed -i "s|DB_DATABASE=.*|DB_DATABASE=/app/database/database.sqlite|" .env

# 7) Composer で依存関係インストール
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# 8) Laravel アプリキーを生成
RUN php artisan key:generate

# 9) データベース・パーミッション整備
RUN mkdir -p database \
 && touch database/database.sqlite \
 && chmod -R 777 database storage bootstrap/cache

# 10) マイグレーション（失敗しても強制終了しない）
RUN php artisan migrate --force || true

# 11) ポートを公開 & Laravel を起動
EXPOSE 8000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
