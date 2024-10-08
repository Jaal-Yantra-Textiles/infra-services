# Define variables
DOMAIN_NAME ?=
ACME_FILE ?= ./acme.json
HASHED_PASSWORD_ENV_VAR ?=
CLOUDFLARE_API_KEY ?=
CLOUDFLARE_EMAIL ?=
CLOUDFLARE_DNS_API_TOKEN ?=

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

# If CLOUDFLARE_API_KEY is not provided, prompt the user for it
ifndef CLOUDFLARE_API_KEY
define CF_API_TOKEN_PROMPT
	@echo "No Cloudflare API token provided."; \
	echo "Please enter the Cloudflare API token:"; \
	read -s cf_token_input; \
	if [ -z "$$cf_token_input" ]; then \
		echo "Error: No Cloudflare API token provided."; \
		exit 1; \
	else \
		CLOUDFLARE_API_KEY=$$cf_token_input; \
		echo "Cloudflare API token successfully set."; \
	fi
endef
else
  CF_API_TOKEN_PROMPT=@echo "Using provided Cloudflare API token."
endif

# If CLOUDFLARE_EMAIL is not provided, prompt the user for it
ifndef CLOUDFLARE_EMAIL
define CF_EMAIL_PROMPT
	@echo "No Cloudflare email provided."; \
	echo "Please enter the Cloudflare email:"; \
	read cf_email_input; \
	if [ -z "$$cf_email_input" ]; then \
		echo "Error: No Cloudflare email provided."; \
		exit 1; \
	else \
		CLOUDFLARE_EMAIL=$$cf_email_input; \
		echo "Cloudflare email successfully set."; \
	fi
endef
else
  CF_EMAIL_PROMPT=@echo "Using provided Cloudflare email: $(CLOUDFLARE_EMAIL)"
endif

# If CLOUDFLARE_DNS_API_TOKEN is not provided, prompt the user for it
ifndef CLOUDFLARE_DNS_API_TOKEN
define CF_DNS_TOKEN_PROMPT
	@echo "No Cloudflare DNS API token provided."; \
	echo "Please enter the Cloudflare DNS API token:"; \
	read -s cf_dns_token_input; \
	if [ -z "$$cf_dns_token_input" ]; then \
		echo "Error: No Cloudflare DNS API token provided."; \
		exit 1; \
	else \
		CLOUDFLARE_DNS_API_TOKEN=$$cf_dns_token_input; \
		echo "Cloudflare DNS API token successfully set."; \
	fi
endef
else
  CF_DNS_TOKEN_PROMPT=@echo "Using provided Cloudflare DNS API token."
endif

# Environment setup target
.PHONY: set-env
set-env:
	$(DOMAIN_PROMPT)
	$(PASSWORD_PROMPT)
	$(CF_API_TOKEN_PROMPT)
	$(CF_EMAIL_PROMPT)
	$(CF_DNS_TOKEN_PROMPT)
	@echo "Final Domain Name: $(DOMAIN_NAME)"
	@echo "Final Hashed Password: $(HASHED_PASSWORD_ENV_VAR)"
	@echo "Final Cloudflare API Token: $(CLOUDFLARE_API_KEY)"
	@echo "Final Cloudflare Email: $(CLOUDFLARE_EMAIL)"
	@echo "Final Cloudflare DNS API Token: $(CLOUDFLARE_DNS_API_TOKEN)"

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
	@DOMAIN_NAME=$(DOMAIN_NAME) \
	HASHED_PASSWORD_ENV_VAR=$(HASHED_PASSWORD_ENV_VAR) \
	CLOUDFLARE_API_KEY=$(CLOUDFLARE_API_KEY) \
	CLOUDFLARE_EMAIL=$(CLOUDFLARE_EMAIL) \
	CLOUDFLARE_DNS_API_TOKEN=$(CLOUDFLARE_DNS_API_TOKEN) \
	docker compose up -d

# Full setup to set environment, create acme.json, and run Traefik
.PHONY: setup
setup: set-env create-acme run-traefik
	@echo "Traefik setup is complete."
