FROM debian:bullseye

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    wget \
    curl \
    unzip \
    lsb-release \
    gnupg \
    apt-transport-https && \
    wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list && \
    apt-get update && \
    apt-get install -y \
    php8.3-fpm \
    php8.3-mysql \
    php8.3-cli \
    php8.3-curl \
    php8.3-xml \
    php8.3-mbstring \
    php8.3-zip \
    php8.3-gd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# copy entry script to container filesystem and give it execution permission
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /var/www/html

# Download and install WordPress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    wp core download --path=/var/www/html --allow-root

# Copy custom PHP-FPM configuration
COPY php-fpm.conf /etc/php/8.3/fpm/php-fpm.conf

# Expose PHP-FPM port
EXPOSE 9000

ENTRYPOINT ["docker-entrypoint.sh"]

