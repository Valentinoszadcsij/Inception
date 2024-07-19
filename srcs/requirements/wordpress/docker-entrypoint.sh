#!/bin/bash
set -e

rm /var/www/html/wp-config.php || true

# Configure database connection and users
wp config create --allow-root --path="/var/www/html" --dbname="$MARIADB_DATABASE" \
    --dbuser="$MARIADB_USER" --dbpass="$MARIADB_PASSWORD" --dbhost="$MARIADB_HOST"

wp core install --allow-root --path="/var/www/html" --url=https://voszadcs.42.fr \
	--admin_user="$WP_ADMIN_NAME" --admin_password="$WP_ADMIN_PASSWORD" \
	--admin_email="voszadcs@student.42heilbronn.de" --title="inception" --skip-email
wp user create --allow-root $WP_USER_NAME "valentinosadchiy@gmail.com" \
    --role=author --user_pass="$WP_USER_PASSWORD"

# Set up WordPress directory permissions
chown -R www-data:www-data /var/www/html

# Start PHP-FPM service
exec php-fpm8.3 -F