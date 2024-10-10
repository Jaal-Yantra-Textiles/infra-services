#!/bin/bash

# Load environment variables from .env file
if [ ! -f .env ]; then
    echo "Error: .env file not found."
    exit 1
fi

# Export all variables from the .env file
export $(grep -v '^#' .env | xargs)

# Define the path to the Docker Compose file
DOCKER_COMPOSE_FILE="mattermost/docker/docker-compose.without-nginx.yml"

# Check if docker-compose.without-nginx.yml exists
if [ ! -f "$DOCKER_COMPOSE_FILE" ]; then
    echo "Error: $DOCKER_COMPOSE_FILE file not found."
    exit 1
fi

# Start the Mattermost services using the specified Docker Compose file
echo "Starting Mattermost services using $DOCKER_COMPOSE_FILE..."
docker compose -f "$DOCKER_COMPOSE_FILE" --env-file .env up -d

# Check if the services started successfully
if [ $? -eq 0 ]; then
    echo "Mattermost services started successfully."
else
    echo "Failed to start Mattermost services."
    exit 1
fi
