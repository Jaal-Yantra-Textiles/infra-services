#!/bin/bash

# Define the Mattermost directories
MATTERMOST_DIR="./volumes/app/mattermost"
DIRECTORIES=(
    "config"
    "data"
    "logs"
    "plugins"
    "client/plugins"
    "bleve-indexes"
)

# Create the directories if they do not exist
echo "Creating Mattermost directories..."
for dir in "${DIRECTORIES[@]}"; do
    mkdir -p "${MATTERMOST_DIR}/${dir}"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create directory ${MATTERMOST_DIR}/${dir}."
        exit 1
    fi
done

# Set the owner to uid 2000 and gid 2000 for Mattermost compatibility
echo "Setting ownership to 2000:2000 for ${MATTERMOST_DIR}..."
sudo chown -R 2000:2000 "${MATTERMOST_DIR}"
if [ $? -ne 0 ]; then
    echo "Error: Failed to set ownership for ${MATTERMOST_DIR}."
    exit 1
fi

echo "Mattermost directories setup completed successfully."
