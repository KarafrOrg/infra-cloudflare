.PHONY: init-all
init-all: ## Initialize all environments
	@echo "Initializing all environments..."
	@cd stacks/prod && make init
	@cd stacks/uat && make init
	@cd stacks/fat && make init

.PHONY: validate-all fmt clean-all
validate-all: ## Validate all environments
	@echo "Validating all environments..."
	@cd stacks/prod && make validate
	@cd stacks/uat && make validate
	@cd stacks/fat && make validate

.PHONY: fmt
fmt: ## Format all Terraform files
	@echo "Formatting all Terraform files..."
	@terraform fmt -recursive

.PHONY: clean-all
clean-all: ## Clean all environments
	@echo "Cleaning all environments..."
	@cd stacks/prod && make clean
	@cd stacks/uat && make clean
	@cd stacks/fat && make clean

.PHONY: check-token
check-token: ## Check if API token is set
	@if [ -z "$$TF_VAR_cloudflare_api_token" ]; then \
		echo "Error: TF_VAR_cloudflare_api_token is not set"; \
		echo ""; \
		echo "Please export your Cloudflare API token:"; \
		echo "  export TF_VAR_cloudflare_api_token=\"your-token-here\""; \
		exit 1; \
	else \
		echo "API token is set"; \
	fi

.PHONY: deploy-prod
deploy-prod: check-token ## Quick deploy Production environment (use with caution!)
	@cd stacks/prod && make init && make plan && make apply

help: ## Show this help message
	@echo ''
	@echo 'Cloudflare Infrastructure - Root Makefile'
	@echo ''
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ''
	@echo 'Environment-specific commands:'
	@echo '  cd stacks/prod && make [target]'
	@echo '  cd stacks/uat  && make [target]'
	@echo '  cd stacks/fat  && make [target]'
