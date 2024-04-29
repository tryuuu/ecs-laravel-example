#!/bin/sh
chown -R www-data:www-data storage
chmod -R 775 storage/logs
php artisan config:cache
php artisan view:cache
# php artisan migrate:fresh --seed --force
ls -l storage/logs

# php-fpmをフォアグラウンドで実行
exec php-fpm