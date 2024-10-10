#!/bin/bash

# Load environment variables from .env file
if [ ! -f .env ]; then
    echo "Error: .env file not found."
    exit 1
fi

# Export all variables from the .env file
export $(grep -v '^#' .env | xargs)

# Define the paths to the Docker Compose files
DOCKER_COMPOSE_FILE="mattermost/docker/docker-compose.yml"
DOCKER_COMPOSE_WITHOUT_NGINX_FILE="mattermost/docker/docker-compose.without-nginx.yml"

# Check if docker-compose.yml and docker-compose.without-nginx.yml exist
if [ ! -f "$DOCKER_COMPOSE_FILE" ] || [ ! -f "$DOCKER_COMPOSE_WITHOUT_NGINX_FILE" ]; then
    echo "Error: Docker Compose files not found in mattermost/docker."
    exit 1
fi

# Start the Mattermost services using both Docker Compose files
echo "Starting Mattermost services using $DOCKER_COMPOSE_FILE and $DOCKER_COMPOSE_WITHOUT_NGINX_FILE..."
sudo docker compose -f "$DOCKER_COMPOSE_FILE" -f "$DOCKER_COMPOSE_WITHOUT_NGINX_FILE" --env-file .env up -d

# Check if the services started successfully
if [ $? -eq 0 ]; then
    echo "Mattermost services started successfully."
else
    echo "Failed to start Mattermost services."
    exit 1
fi
