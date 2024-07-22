
COMPOSE		= docker compose -f srcs/docker-compose.yml

all: up

up: volume build
	sudo $(COMPOSE) up
build:
	sudo $(COMPOSE) build --no-cache

volume:
	sudo mkdir -p /home/voszadcs/data/wp_db
	sudo mkdir -p /home/voszadcs/data/wp_files
	sudo chown -R voszadcs:voszadcs /home/voszadcs/data/wp_db || true
	sudo chown -R voszadcs:voszadcs /home/voszadcs/data/wp_files || true
	sudo chmod -R 755 /home/voszadcs/data/wp_db
	sudo chmod -R 755 /home/voszadcs/data/wp_files
clean:
	sudo docker stop $(shell docker ps -qa) || true
	sudo docker rm $(shell docker ps -qa) || true
	sudo docker rmi $(shell docker images -q) || true
	sudo docker volume rm $(shell docker volume ls -q) || true
	sudo docker network rm $(shell docker network ls -q) 2>/dev/null || true
stop:
	sudo $(COMPOSE) stop
start:
	sudo $(COMPOSE) up

re:	clean up