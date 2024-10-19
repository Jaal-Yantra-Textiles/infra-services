# Makefile

ENV_FILE := .env

include $(ENV_FILE)
export $(shell sed 's/=.*//' $(ENV_FILE))

SERVICE_NAME := affine_selfhosted
CONFIG_PATH := ~/.affine/self-host/config/affine.js
CUSTOM_CONFIG := ./config/affine.js

.PHONY: up down restart copy-config logs ps clean

up: ## Start Docker Compose services
	@echo "Starting Docker Compose services..."
	docker-compose up -d

down: ## Stop Docker Compose services
	@echo "Stopping Docker Compose services..."
	docker-compose down

restart: down up ## Restart Docker Compose services

logs: ## View Docker Compose logs
	docker-compose logs -f

ps: ## List running Docker Compose containers
	docker-compose ps

pull: ## Pull latest Docker images
	docker-compose pull

build: ## Build Docker images
	docker-compose build

copy-config: ## Copy custom affine.js to the container and restart service
	@echo "Copying custom affine.js to container..."
	# Ensure the config directory exists locally
	mkdir -p ~/.affine/self-host/config
	# Copy the new affine.js to the local config path
	cp $(CUSTOM_CONFIG) $(CONFIG_PATH)
	@echo "Copied affine.js to $(CONFIG_PATH). Restarting container..."
	# Restart the affine service to apply the new configuration
	docker-compose restart $(SERVICE_NAME)

clean: ## Remove unused Docker images and volumes
	@echo "Removing unused Docker resources..."
	docker system prune -f
	docker volume prune -f
