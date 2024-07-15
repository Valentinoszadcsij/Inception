#!/bin/bash
set -e

# initialize MariaDB
mkdir -p /var/run/mysqld
chown -R root:root /var/run/mysqld # socket files will be created here
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Initializing MariaDB data directory..."
	mysql_install_db --user=root --datadir=/var/lib/mysql # Mariadb data directory
fi

# start MariaDB service 
echo "Starting MariaDB..."
mysqld --user=root &
pid="$!"

echo "Waiting for MariaDB to be ready..."
while ! mysqladmin ping --silent; do
    sleep 1
done

# create database and user
echo "creating DB and user"
mysql -u root -e "CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE;"
mysql -u root -e "CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';"
mysql -u root -e "GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'%';"
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

echo "Shutting down MariaDB..."
mysqladmin -u root -p"$MARIADB_ROOT_PASSWORD" shutdown

echo "Restarting MariaDB..."
exec mysqld --user=root --datadir=/var/lib/mysql