# 1) PHP 8.3 CLI イメージをベースにする
FROM php:8.3-cli

# 2) 必要な拡張やライブラリを入れる
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libicu-dev \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install \
    pdo_mysql \
    mbstring \
    zip

# 3) Composer を手動インストール
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

# 4) 作業ディレクトリとソースコードをコピー
WORKDIR /app
COPY . /app

# 5) Laravel セットアップ
RUN cp .env.example .env \
    && composer install \
    && php artisan key:generate

RUN chmod -R 777 storage \
    && chmod -R 777 bootstrap/cache \
    && chmod -R 777 database

EXPOSE 8000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
