FROM composer


EXPOSE 8000
COPY ./ /app
WORKDIR /app


RUN cp .env.example .env;
RUN composer install;
RUN php artisan key:generate;
RUN php artisan migrate --force;

RUN chmod -R 775 storage
RUN chmod -R 775 bootstrap/cache

RUN ls -lh

CMD php artisan serve --host 0.0.0.0 --port 8000