.PHONY: help init plan apply destroy validate fmt output clean

# Default environment
ENV ?= prod

help: ## Show this help message
	@echo ''
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## Initialize Terraform
	@echo "Initializing Production Stack..."
	terraform init

validate: ## Validate Terraform configuration
	@echo "Validating Production Stack..."
	terraform validate

fmt: ## Format Terraform files
	@echo "Formatting Terraform files..."
	terraform fmt -recursive

plan: ## Plan changes
	@echo "Planning Production Stack changes..."
	terraform plan -var-file="prod.tfdeploy.hcl"

apply: ## Apply changes
	@echo "Applying Production Stack changes..."
	terraform apply -var-file="prod.tfdeploy.hcl"

destroy: ## Destroy resources
	@echo "Destroying Production Stack resources..."
	terraform destroy -var-file="prod.tfdeploy.hcl"

output: ## Show Terraform outputs
	@echo "Production Stack outputs:"
	@terraform output

get-zone-id: ## Get zone_id
	@terraform output -raw zone_id 2>/dev/null || echo "No zone_id found. Deploy first with 'make apply'"

get-nameservers: ## Get nameservers
	@terraform output -json nameservers 2>/dev/null || echo "No nameservers found. Deploy first with 'make apply'"

clean: ## Clean Terraform files
	@echo "Cleaning Production Stack files..."
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f *.tfstate*
