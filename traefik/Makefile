# Define variables
DOMAIN_NAME ?= example.com
ACME_FILE ?= ./acme.json

# If HASHED_PASSWORD_ENV_VAR is not provided, prompt the user for a password
ifndef HASHED_PASSWORD_ENV_VAR
define PASSWORD_PROMPT
	@echo "Please enter a password for basic authentication:"; \
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
  PASSWORD_PROMPT=@echo "Using provided hashed password: $(HASHED_PASSWORD_ENV_VAR)"
endif

# Environment setup target
.PHONY: set-env
set-env:
	@echo "Setting environment variables..."
	@echo "DOMAIN_NAME=$(DOMAIN_NAME)"
	$(PASSWORD_PROMPT)

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
	@DOMAIN_NAME=$(DOMAIN_NAME) HASHED_PASSWORD_ENV_VAR=$(HASHED_PASSWORD_ENV_VAR) docker-compose up -d

# Full setup to set environment, create acme.json, and run Traefik
.PHONY: setup
setup: set-env create-acme run-traefik
	@echo "Traefik setup is complete."
