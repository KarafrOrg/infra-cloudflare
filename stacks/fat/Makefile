.PHONY: help init plan apply destroy validate fmt output clean

# Default environment
ENV ?= fat

help: ## Show this help message
	@echo ''
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## Initialize Terraform
	@echo "Initializing FAT Stack..."
	terraform init

validate: ## Validate Terraform configuration
	@echo "Validating FAT Stack..."
	terraform validate

fmt: ## Format Terraform files
	@echo "Formatting Terraform files..."
	terraform fmt -recursive

plan: ## Plan changes
	@echo "Planning FAT Stack changes..."
	terraform plan -var-file="fat.tfdeploy.hcl"

apply: ## Apply changes
	@echo "Applying FAT Stack changes..."
	terraform apply -var-file="fat.tfdeploy.hcl"

destroy: ## Destroy resources
	@echo "Destroying FAT Stack resources..."
	terraform destroy -var-file="fat.tfdeploy.hcl"

output: ## Show Terraform outputs
	@echo "FAT Stack outputs:"
	@terraform output

get-zone-id: ## Get zone_id
	@terraform output -raw zone_id 2>/dev/null || echo "No zone_id found. Deploy first with 'make apply'"

get-nameservers: ## Get nameservers
	@terraform output -json nameservers 2>/dev/null || echo "No nameservers found. Deploy first with 'make apply'"

clean: ## Clean Terraform files
	@echo "Cleaning FAT Stack files..."
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f *.tfstate*

# Examples:
# make init
# make plan
# make apply
# make get-zone-id
# make get-nameservers
# make output

