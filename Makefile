COMPOSE		= docker compose -f srcs/docker-compose.yml

all: build up

up: volume build
	$(COMPOSE) up
build:
	$(COMPOSE) build
# for now this is a path on MacOs, later need to change to home/user_name/data on VM
volume:
	mkdir -p /Users/voszadcs/Documents/data
clean:
	$(COMPOSE) down
	docker stop $(shell docker ps -qa) || true
	docker rm $(shell docker ps -qa) || true
	docker rmi $(shell docker images -q) || true
	docker volume rm $(shell docker volume ls -q) || true
	docker network rm $(shell docker network ls -q) 2>/dev/null || true
re:	clean up