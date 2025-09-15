# Terraform Makefile for common operations

.PHONY: help init plan apply destroy validate format check

# Default target
help:
	@echo "Available targets:"
	@echo "  init     - Initialize Terraform"
	@echo "  plan     - Plan Terraform changes"
	@echo "  apply    - Apply Terraform changes"
	@echo "  destroy  - Destroy Terraform resources"
	@echo "  validate - Validate Terraform configuration"
	@echo "  format   - Format Terraform files"
	@echo "  check    - Run Terraform validation and formatting"

# Initialize Terraform
init:
	terraform init

# Plan changes
plan:
	terraform plan

# Apply changes
apply:
	terraform apply

# Destroy resources
destroy:
	terraform destroy

# Validate configuration
validate:
	terraform validate

# Format Terraform files
format:
	terraform fmt -recursive

# Check configuration (validate + format)
check: validate format
	@echo "Terraform configuration check completed"

# Environment-specific targets
dev-init:
	cd environments/dev && terraform init

dev-plan:
	cd environments/dev && terraform plan

dev-apply:
	cd environments/dev && terraform apply

dev-destroy:
	cd environments/dev && terraform destroy

staging-init:
	cd environments/staging && terraform init

staging-plan:
	cd environments/staging && terraform plan

staging-apply:
	cd environments/staging && terraform apply

staging-destroy:
	cd environments/staging && terraform destroy

prod-init:
	cd environments/prod && terraform init

prod-plan:
	cd environments/prod && terraform plan

prod-apply:
	cd environments/prod && terraform apply

prod-destroy:
	cd environments/prod && terraform destroy
