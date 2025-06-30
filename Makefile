DOCKER_COMPOSE = docker compose -f srcs/docker-compose.yml
ENV_FILE = srcs/.env

GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
BLUE = \033[0;34m
NC = \033[0m

.PHONY: all build up down restart clean fclean ps logs

all: build up

build:
	@echo "${BLUE}Building Docker images...${NC}"
	@${DOCKER_COMPOSE} build

up:
	@echo "${GREEN}Starting containers...${NC}"
	@${DOCKER_COMPOSE} up -d
	@echo "${GREEN}Containers started successfully!${NC}"
	@echo "${YELLOW}Please wait a few moments for all services to be ready...${NC}"
	@sleep 5
	@echo "${GREEN}To view logs in real time, run: make logs${NC}"
	@${DOCKER_COMPOSE} ps

down:
	@echo "${YELLOW}Stopping containers...${NC}"
	@${DOCKER_COMPOSE} down
	@echo "${GREEN}Containers stopped successfully!${NC}"

restart: down up

clean:
	@echo "${YELLOW}Cleaning containers...${NC}"
	@${DOCKER_COMPOSE} down -v --remove-orphans
	@echo "${GREEN}Containers cleaned successfully!${NC}"

fclean: clean
	@echo "${RED}Complete removal of containers, images and volumes...${NC}"
	@docker system prune -af
	@echo "${GREEN}Complete removal finished!${NC}"

ps:
	@echo "${BLUE}Containers state:${NC}"
	@${DOCKER_COMPOSE} ps

logs:
	@echo "${BLUE}Logs display (ctrl+c to quit)...${NC}"
	@${DOCKER_COMPOSE} logs -f

log-%:
	@echo "${BLUE}Logs display for $* (ctrl+c to quit)...${NC}"
	@${DOCKER_COMPOSE} logs -f $*

env:
	@echo "${BLUE}Environment variables:${NC}"
	@cat ${ENV_FILE}

shell-%:
	@echo "${BLUE}Opening shell in container $*...${NC}"
	@${DOCKER_COMPOSE} exec $* /bin/bash || ${DOCKER_COMPOSE} exec $* /bin/sh

restart-%:
	@echo "${YELLOW}Restarting service $*...${NC}"
	@${DOCKER_COMPOSE} restart $*
	@echo "${GREEN}Service $* restarted!${NC}"

build-%:
	@echo "${BLUE}Building image $*...${NC}"
	@${DOCKER_COMPOSE} build $*
	@echo "${GREEN}Image $* built!${NC}"


help:
	@echo "${BLUE}=== AVAILABLE COMMANDS ===${NC}"
	@echo "${GREEN}make all${NC}        - Build images and start containers"
	@echo "${GREEN}make build${NC}      - Build all Docker images"
	@echo "${GREEN}make build-X${NC}    - Build image for service X (ex: make build-wordpress)"
	@echo "${GREEN}make up${NC}         - Start all containers"
	@echo "${GREEN}make down${NC}       - Stop all containers"
	@echo "${GREEN}make restart${NC}    - Restart all containers"
	@echo "${GREEN}make restart-X${NC}  - Restart service X (ex: make restart-nginx)"
	@echo "${GREEN}make clean${NC}      - Stop and remove containers"
	@echo "${GREEN}make fclean${NC}     - Completely remove containers, images and volumes"
	@echo "${GREEN}make ps${NC}         - Display container status"
	@echo "${GREEN}make logs${NC}       - Display logs from all containers"
	@echo "${GREEN}make log-X${NC}      - Display logs from service X (ex: make log-wordpress)"
	@echo "${GREEN}make shell-X${NC}    - Open shell in container X (ex: make shell-mariadb)"
	@echo "${GREEN}make env${NC}        - Display environment variables"