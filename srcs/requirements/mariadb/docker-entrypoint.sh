#!/bin/bash
set -e

# initialize MariaDB
echo "Running MariaDB init script"
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

echo "Initializing DB"
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# start MariaDB service 
echo "Starting MariaDB..."
chown -R mysql:mysql /var/lib/mysql
mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
pid="$!"

echo "Waiting for MariaDB to be ready..."
while ! mysqladmin ping --silent; do
    echo "-"
    sleep 1
done

# create database and user
echo "Creating DB and user"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE;"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'%';"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

echo "Shutting down MariaDB..."
mysqladmin -u root -p"$MARIADB_ROOT_PASSWORD" shutdown

echo "Restarting MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql