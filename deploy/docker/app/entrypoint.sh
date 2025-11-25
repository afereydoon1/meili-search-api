#!/bin/sh
set -e

# Generate configurations from templates
envsubst < /usr/local/etc/php/php.ini.template > /usr/local/etc/php/php.ini

# Create Laravel required directories if they don't exist
mkdir -p /var/www/storage/framework/{sessions,views,cache}
mkdir -p /var/www/storage/logs
mkdir -p /var/www/bootstrap/cache

# Fix ownership and permissions
echo "🔧 Fixing ownership and permissions..."
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
find /var/www/storage -type d -exec chmod 775 {} \;
find /var/www/storage -type f -exec chmod 664 {} \;
find /var/www/bootstrap/cache -type d -exec chmod 775 {} \;
find /var/www/bootstrap/cache -type f -exec chmod 664 {} \;

# Run the main container command (php-fpm)
exec "$@"
