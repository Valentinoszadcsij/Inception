COMPOSE		= docker compose -f srcs/docker-compose.yml

all: build up

up: volume build
	sudo $(COMPOSE) up
build:
	sudo $(COMPOSE) build
# for now this is a path on MacOs, later need to change to home/user_name/data on VM
volume:
	sudo mkdir -p /home/$(shell whoami)/Documents/data
	sudo chown -R $(shell whoami):$(shell whoami) /home/$(shell whoami)/Documents/data
	sudo chmod -R 755 /home/$(shell whoami)/Documents/data
clean:
	sudo $(COMPOSE) down
	sudo docker stop $(shell docker ps -qa) || true
	sudo docker rm $(shell docker ps -qa) || true
	sudo docker rmi $(shell docker images -q) || true
	sudo docker volume rm $(shell docker volume ls -q) || true
	sudo docker network rm $(shell docker network ls -q) 2>/dev/null || true
re:	clean up