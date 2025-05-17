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

# 3) 作業ディレクトリを設定
WORKDIR /app

# 4) Laravel プロジェクトをコピー
COPY . /app

# 5) .env.example を .env にコピー
RUN cp .env.example .env

# (注) もし .env.example が SQLite 用に設定されていない場合、sed などで書き換える例:
# RUN sed -i "s/DB_CONNECTION=.*/DB_CONNECTION=sqlite/" .env
# RUN sed -i "s|DB_DATABASE=.*|DB_DATABASE=/app/database/database.sqlite|" .env

# 6) Composer で依存関係をインストール
RUN composer install

# 7) Laravel アプリキーを生成
RUN php artisan key:generate

# 8) SQLite 用のファイルを作成
RUN mkdir -p database \
 && touch database/database.sqlite \
 && chmod -R 777 database storage bootstrap/cache

# 9) マイグレーション（開発・デモ用）
RUN php artisan migrate --force || true

#RUN export HOME=/root
#RUN git config --global user.email "kenken999@users.noreply.huggingface.co"

#RUN git config --system user.email "kenken999@users.noreply.huggingface.co"
#RUN git config --system user.name "Your Name"

# 10) ポート公開 & 実行コマンド
EXPOSE 8000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
