FROM bitnami/laravel;


EXPOSE 8000
COPY ./ /app
WORKDIR /app

RUN  touch database\database.sqlite;
RUN php artisan migrate;
