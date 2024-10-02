#!/bin/sh

# Set permissions for acme.json
chmod 600 /acme.json

# Start Traefik
traefik "$@"
