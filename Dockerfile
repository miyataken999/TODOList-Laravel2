FROM composer:2.5-php8.3


EXPOSE 8000
COPY ./ /app
WORKDIR /app


RUN cp .env.example .env;
RUN composer install;
RUN php artisan key:generate;
RUN php artisan migrate --force;

RUN ls -lh

# RUN chmod -R 777 public
RUN chmod -R 777 storage
RUN chmod -R 777 database
RUN chmod -R 777 bootstrap/cache

RUN ls -lh

CMD php artisan serve --host 0.0.0.0 --port 8000