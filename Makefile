COMPOSE		= docker compose -f srcs/docker-compose.yml

all: build up

up: build
	$(COMPOSE) up
build:
	$(COMPOSE) build
clean:
	$(COMPOSE) down
	docker rmi $(shell $(COMPOSE) images -q)
re:	clean up