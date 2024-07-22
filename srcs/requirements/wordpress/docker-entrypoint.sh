#!/bin/bash
set -e

# Wait for MariaDB to be ready
sleep 10

# Download WP-CLI
cd /var/www/html
if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Download WordPress core files, configure and install Wp

    wp core download --allow-root || echo "Skipping wp core download"
    wp config create --dbname=$MARIADB_DATABASE --dbuser=$MARIADB_USER --dbpass=$MARIADB_PASSWORD --dbhost=$MARIADB_HOST --allow-root || echo "Skipping wp config create"
    chmod 777 wp-config.php
    wp core install --url="https://voszadcs.42.fr" --title="inception" --admin_user=$WP_ADMIN_NAME --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root || echo "Skipping wp core install"


# Create a new user
 if ! wp user get "$WP_USER_NAME" --field=ID --allow-root > /dev/null 2>&1; then
    # If the user does not exist, create it
    wp user create --allow-root "$WP_USER_NAME" "valentinosadchiy@gmail.com" \
        --role=author --user_pass="$WP_USER_PASSWORD"
else
    echo "User $WP_USER_NAME already exists. Skipping creation."
fi

# Update WordPress options
wp option update home "https://127.0.0.1" --allow-root
wp option update siteurl "https://127.0.0.1" --allow-root

# Ensure proper ownership and permissions for uploads directory
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/

# Start PHP-FPM
exec php-fpm8.3 -F