#!/bin/bash

# Function to check if a command was successful
check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed. Exiting."
        exit 1
    fi
}

# Step 1: Check git submodule update --init --recursive
echo "Updating git submodules..."
git submodule update --init --recursive
check_success "Git submodule update"

# Step 2: Verify Mattermost Docker submodule exists
MATTERMOST_DIR="mattermost/docker"
if [ ! -d "$MATTERMOST_DIR" ]; then
    echo "Error: Mattermost Docker submodule directory '$MATTERMOST_DIR' does not exist."
    exit 1
fi

# Step 3: Locate the docker-compose.yml file in the Mattermost Docker directory
DOCKER_COMPOSE_FILE="$MATTERMOST_DIR/docker-compose.yml"
if [ ! -f "$DOCKER_COMPOSE_FILE" ]; then
    echo "Error: docker-compose.yml file not found in '$MATTERMOST_DIR'."
    exit 1
fi

echo "Found docker-compose.yml at $DOCKER_COMPOSE_FILE"

# Step 4: Append the Traefik labels to the docker-compose.yml file
echo "Appending Traefik labels to docker-compose.yml..."

cat <<EOL >> "$DOCKER_COMPOSE_FILE"

# Traefik Labels for Mattermost
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.chat.rule=Host(\`\${DOMAIN}\`)"
      - "traefik.http.routers.chat.entrypoints=web"
      - "traefik.http.services.chat.loadbalancer.server.port=8065"
      - "traefik.http.routers.chat.entrypoints=websecure"
      - "traefik.http.routers.chat.tls.certresolver=myresolver"

EOL

# Verify that the labels were appended
if grep -q "traefik.enable=true" "$DOCKER_COMPOSE_FILE"; then
    echo "Traefik labels successfully appended to docker-compose.yml."
else
    echo "Error: Failed to append Traefik labels."
    exit 1
fi

echo "Script completed successfully."
