# Define variables
DOMAIN_NAME ?=
ACME_FILE ?= ./acme.json
HASHED_PASSWORD_ENV_VAR ?=

# If HASHED_PASSWORD_ENV_VAR is not provided, prompt the user for a password
ifndef HASHED_PASSWORD_ENV_VAR
define PASSWORD_PROMPT
	@echo "No hashed password provided."; \
	echo "Please enter a password for basic authentication:"; \
	read -s password_input; \
	 if [ -z "$$password_input" ]; then \
	    echo "Error: No password provided."; \
	    exit 1; \
	 else \
	    HASHED_PASSWORD_ENV_VAR=$$(openssl passwd -apr1 "$$password_input" | sed -e 's/\$$/\\$$/g'); \
	    echo "Password successfully hashed."; \
	 fi
endef
else
  PASSWORD_PROMPT=@echo "Using provided hashed password."
endif

# If DOMAIN_NAME is not provided, prompt the user for it
ifndef DOMAIN_NAME
define DOMAIN_PROMPT
	@echo "No domain name provided."; \
	echo "Please enter a domain name:"; \
	read domain_input; \
	if [ -z "$$domain_input" ]; then \
		echo "Error: No domain name provided."; \
		exit 1; \
	else \
		DOMAIN_NAME=$$domain_input; \
		echo "Domain name set to $$domain_input"; \
	fi
endef
else
  DOMAIN_PROMPT=@echo "Using provided domain name: $(DOMAIN_NAME)"
endif

# Environment setup target
.PHONY: set-env
set-env:
	$(DOMAIN_PROMPT)
	$(PASSWORD_PROMPT)
	@echo "Final Domain Name: $(DOMAIN_NAME)"
	@echo "Final Hashed Password: $(HASHED_PASSWORD_ENV_VAR)"

# Task to create acme.json and set correct permissions
.PHONY: create-acme
create-acme:
	@echo "Creating acme.json file with 600 permissions..."
	@touch $(ACME_FILE)
	@chmod 600 $(ACME_FILE)

# Task to run Traefik with Docker Compose
.PHONY: run-traefik
run-traefik: create-acme set-env
	@echo "Running Traefik with domain $(DOMAIN_NAME)..."
	@DOMAIN_NAME=$(DOMAIN_NAME) HASHED_PASSWORD_ENV_VAR=$(HASHED_PASSWORD_ENV_VAR) docker compose up -d

# Full setup to set environment, create acme.json, and run Traefik
.PHONY: setup
setup: set-env create-acme run-traefik
	@echo "Traefik setup is complete."
