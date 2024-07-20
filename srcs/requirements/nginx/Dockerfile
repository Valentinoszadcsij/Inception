FROM debian:bullseye

# Update package list and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    nginx \
    openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 443

# Generate SSL certificate
RUN mkdir -p /etc/nginx/certs && \
    cd /etc/nginx/certs && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certs/selfsigned.key -out /etc/nginx/certs/selfsigned.crt -subj "/C=DE/State=BW/L=HEILBRONN/O=42HEILBRONN/OU=STUDENT/CN=localhost"

COPY default.conf /etc/nginx/conf.d/default.conf

# Start NGINX in foreground
ENTRYPOINT ["nginx", "-g", "daemon off;"]