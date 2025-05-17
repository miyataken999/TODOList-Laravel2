#!/bin/sh
echo "🛠 Fixing permissions..."
chmod -R 777 storage bootstrap/cache
chmod -R 777 database
echo "🚀 Launching Laravel..."
php artisan serve --host=0.0.0.0 --port=8888
