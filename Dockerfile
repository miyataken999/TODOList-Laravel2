# Node.js ベース（n8n 対応環境）
FROM node:18.17.0

# ポート公開（n8nとLaravel両方に対応）
EXPOSE 7860
EXPOSE 8000

# 環境変数（n8n）
ENV N8N_PORT=7860
ENV WEBHOOK_URL=https://kenken999-nodex-n8n-domain.hf.space/
ENV VUE_APP_URL_BASE_API=https://kenken999-nodex-n8n-domain.hf.space/

# --- n8n をグローバルインストール ---
RUN npm install -g n8n

# --- PHP + Laravel 環境構築 ---
RUN apt-get update && apt-get install -y \
    php \
    php-cli \
    php-mbstring \
    php-xml \
    php-sqlite3 \
    php-mysql \
    php-curl \
    php-zip \
    php-bcmath \
    unzip \
    git \
    wget \
    curl \
    sqlite3 \
    libsqlite3-dev

# Composerインストール
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Laravel用の作業ディレクトリ
WORKDIR /app
COPY . /app

# .env 設定（必要に応じて修正）
RUN cp .env.example .env

# Composer install & Laravel初期化
RUN composer install --no-interaction --prefer-dist --optimize-autoloader \
 && php artisan key:generate \
 && mkdir -p database && touch database/database.sqlite \
 && chmod -R 777 database storage bootstrap/cache \
 && php artisan migrate --force || true

# git の設定（グローバルが機能するNode.jsベースなのでOK）
RUN git config --global user.email "kenken999@users.noreply.huggingface.co"

# --- デフォルトは Laravel 起動（n8n と切り替え可能）---
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]

# n8n を代わりに起動したい場合は以下に切り替え可能：
# CMD ["n8n", "start"]
