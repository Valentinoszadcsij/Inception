FROM debian:bullseye

# install and configure mariadb server

RUN apt-get update && apt-get install -y mariadb-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3306

# copy entry script to container filesystem and give it execution permission
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
COPY my.cnf /etc/mysql/my.cnf


# set entrypoint script and command that will be executed in container when it starts
ENTRYPOINT [ "docker-entrypoint.sh" ]

