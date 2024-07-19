COMPOSE		= docker compose -f srcs/docker-compose.yml

all: build up

up: volume build
	sudo $(COMPOSE) up
build:
	sudo $(COMPOSE) build --no-cache

volume:
	sudo mkdir -p /home/voszadcs/data/wp_db
	sudo mkdir -p /home/voszadcs/data/wp_files
	sudo chown -R $(shell whoami):$(shell whoami) /home/voszadcs/data/wp_db
	sudo chown -R $(shell whoami):$(shell whoami) /home/voszadcs/data/wp_files
	sudo chmod -R 755 /home/voszadcs/data/wp_db
	sudo chmod -R 755 /home/voszadcs/data/wp_files
clean:
#	sudo $(COMPOSE) down
	sudo docker stop $(shell docker ps -qa) || true
	sudo docker rm $(shell docker ps -qa) || true
	sudo docker rmi $(shell docker images -q) || true
	sudo docker volume rm $(shell docker volume ls -q) || true
	sudo docker network rm $(shell docker network ls -q) 2>/dev/null || true
# clean:
# 	sudo $(COMPOSE) down --remove-orphans
# 	sudo docker stop $(shell docker ps -qa) || true
# 	sudo docker rm $(shell docker ps -qa) || true
# 	sudo docker image prune -af --filter "until=24h"
# 	sudo docker volume prune -f
# 	sudo docker network prune -f --filter "until=24h"

re:	clean up