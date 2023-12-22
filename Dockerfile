FROM composer


EXPOSE 8000
COPY ./ /app
WORKDIR /app


RUN cp .env.example .env;
RUN composer install;
RUN php artisan key:generate;
RUN php artisan migrate --force;
RUN php artisan serve --host 0.0.0.0 --port 8000