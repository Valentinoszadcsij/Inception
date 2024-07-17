COMPOSE		= docker compose -f srcs/docker-compose.yml

all: build up

up: volume build
	sudo $(COMPOSE) up
build:
	sudo $(COMPOSE) build
# for now this is a path on MacOs, later need to change to home/user_name/data on VM
volume:
	sudo mkdir -p /home/voszadcs/data/wp_db
	sudo chown -R $(shell whoami):$(shell whoami) /home/voszadcs/data/wp_db
	sudo chmod -R 755 /home/voszadcs/data/wp_db
clean:
	sudo $(COMPOSE) down
	sudo docker stop $(shell docker ps -qa) || true
	sudo docker rm $(shell docker ps -qa) || true
	sudo docker rmi $(shell docker images -q) || true
	sudo docker volume rm $(shell docker volume ls -q) || true
	sudo docker network rm $(shell docker network ls -q) 2>/dev/null || true
re:	clean up