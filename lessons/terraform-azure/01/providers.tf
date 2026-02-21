provider "azurerm" {
  # This instructs the provider to use your existing Azure CLI connection for authentication
  use_cli = true

  # This ensures no resource provider registrations are performed by Terraform
  resource_provider_registrations = "none"

  subscription_id = var.subscription_id

  # This is a required block which contains any advanced configuration options you may need - don't worry worry about it for now
  features {}
}
