FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install -y \
	php-fpm \
	lsb-release \
	apt-transport-https \
	ca-certificates \
	php-mysqli \
	curl

# Add Sury PHP repository
RUN curl -sSL https://packages.sury.org/php/README.txt | bash

# Install PHP 8.2 and necessary modules
RUN apt update && apt install -y \
    php8.3-fpm \
    php8.3-mysqli \
    curl
RUN mkdir -p /run/php && chown www-data:www-data /run/php
COPY www.conf /etc/php/8.3/fpm/pool.d/.
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]