# Makefile

COMMUNITY_DIR := community-edition
DOCKER_COMPOSE_FILE := ../$(COMMUNITY_DIR)/docker-compose.yml
DEST_DOCKER_COMPOSE := ./docker-compose.yml

.PHONY: all check-submodule copy-config up down restart logs ps clean

all: check-submodule copy-config

check-submodule:
	@echo "Checking if the submodule $(COMMUNITY_DIR) exists..."
	if [ ! -d "$(COMMUNITY_DIR)" ]; then \
		echo "Submodule not found. Initializing submodule..."; \
		git submodule update --init --recursive; \
	else \
		echo "Submodule $(COMMUNITY_DIR) exists."; \
	fi

copy-config:
	@echo "Copying docker-compose.yml from $(COMMUNITY_DIR) to the working directory..."
	if [ -f "$(DOCKER_COMPOSE_FILE)" ]; then \
		cp $(DOCKER_COMPOSE_FILE) $(DEST_DOCKER_COMPOSE); \
		echo "docker-compose.yml copied successfully."; \
	else \
		echo "Error: docker-compose.yml not found in $(COMMUNITY_DIR)."; \
		exit 1; \
	fi
	@echo "Adding Traefik labels to docker-compose.yml..."
	@echo "\nservices:" >> $(DEST_DOCKER_COMPOSE)
	@echo "  labels:" >> $(DEST_DOCKER_COMPOSE)
	@echo "    - \"traefik.enable=true\"" >> $(DEST_DOCKER_COMPOSE)
	@echo "    - \"traefik.http.routers.analytics.rule=Host(\`analytics.cynsar.capital\`)\"" >> $(DEST_DOCKER_COMPOSE)
	@echo "    - \"traefik.http.routers.analytics.entrypoints=web\"" >> $(DEST_DOCKER_COMPOSE)
	@echo "    - \"traefik.http.services.analytics.loadbalancer.server.port=8000\"" >> $(DEST_DOCKER_COMPOSE)
	@echo "    - \"traefik.http.routers.analytics.entrypoints=websecure\"" >> $(DEST_DOCKER_COMPOSE)
	@echo "    - \"traefik.http.routers.analytics.tls.certresolver=myresolver\"" >> $(DEST_DOCKER_COMPOSE)
	@echo "Labels added successfully."

up:
	@echo "Starting Docker Compose services..."
	docker compose up -d

down:
	@echo "Stopping Docker Compose services..."
	docker compose down

restart: down up

logs:
	@docker compose logs -f

ps:
	@docker compose ps

clean:
	@echo "Cleaning up unused Docker resources..."
	docker system prune -f
	docker volume prune -f
