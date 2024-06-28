#!/bin/bash
set -e

# initialize MariaDB data directory
# if [ ! -d /var/lib/mysql/mysql ]; then
# 	mysql_install_db --user=mysql --datadir=/var/lib/mysql
# fi

# start MariaDB service 
mysqld_safe --datadir=/var/lib/mysql &
while ! mysqladmin ping --silent; do
    sleep 1
done

# create database and user
echo "creating DB and user" > /var/lib/mysql/test
mysql -e "CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE;"
mysql -e "CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';"
mysql -e "GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'%';"
mysql -e "FLUSH PRIVILEGES;"

mysqladmin shutdown
exec mysqld_safe --datadir=/var/lib/mysql