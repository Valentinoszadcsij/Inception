FROM debian:latest

# install and configure mariadb server

RUN sudo apt-get update && sudo apt-get install -y mariadb-server \
    && sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3306

# copy entry script to container filesystem and give it execution permission
COPY docker-entrypoint.sh /usr/local/bin/
RUN sudo chmod +x /usr/local/bin/docker-entrypoint.sh

# set entrypoint script and command that will be executed in container when it starts
ENTRYPOINT [ "docker-entrypoint.sh" ]

