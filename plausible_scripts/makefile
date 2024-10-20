# Makefile

COMMUNITY_DIR := ../community-edition
ORIGINAL_COMPOSE := $(COMMUNITY_DIR)/compose.yml
DEST_COMPOSE := $(COMMUNITY_DIR)/compose.yml
OVERRIDE_SOURCE := ./docker-compose.override.yml
OVERRIDE_DEST := $(COMMUNITY_DIR)/docker-compose.override.yml

.PHONY: all check-submodule copy-config copy-override up down restart logs ps clean

all: check-submodule copy-config copy-override

check-submodule:
	@echo "Checking if the submodule $(COMMUNITY_DIR) exists..."
	@if [ ! -d "$(COMMUNITY_DIR)" ]; then \
		echo "Submodule not found. Initializing submodule..."; \
		git submodule update --init --recursive; \
	else \
		echo "Submodule $(COMMUNITY_DIR) exists."; \
	fi

copy-config:
	@echo "Copying docker-compose.yml from $(COMMUNITY_DIR) to the working directory..."
	@if [ -f "$(ORIGINAL_COMPOSE)" ]; then \
		cp "$(ORIGINAL_COMPOSE)" "$(DEST_COMPOSE)"; \
		echo "docker-compose.yml copied successfully."; \
	else \
		echo "Error: docker-compose.yml not found in $(COMMUNITY_DIR)."; \
		exit 1; \
	fi

copy-override:
	@echo "Copying docker-compose.override.yml to the working directory..."
	@if [ -f "$(OVERRIDE_SOURCE)" ]; then \
		cp "$(OVERRIDE_SOURCE)" "$(OVERRIDE_DEST)"; \
		echo "docker-compose.override.yml copied successfully."; \
	else \
		echo "Error: docker-compose.override.yml not found."; \
		exit 1; \
	fi

up:
	@echo "Starting Docker Compose services with multiple compose files..."
	@docker compose -f "$(DEST_COMPOSE)" -f "$(OVERRIDE_DEST)" up -d

down:
	@echo "Stopping Docker Compose services..."
	@docker compose -f "$(DEST_COMPOSE)" -f "$(OVERRIDE_DEST)" down

restart: down up

logs:
	@echo "Showing Docker Compose logs..."
	@docker compose -f "$(DEST_COMPOSE)" -f "$(OVERRIDE_DEST)" logs -f

ps:
	@echo "Listing Docker Compose services..."
	@docker compose -f "$(DEST_COMPOSE)" -f "$(OVERRIDE_DEST)" ps

clean:
	@echo "Cleaning up unused Docker resources..."
	@docker system prune -f
	@docker volume prune -f
