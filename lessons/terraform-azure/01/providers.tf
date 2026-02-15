provider "azurerm" {
  # This instructs the provider to use your existing Azure CLI connection for authentication
  use_cli = true

  # This ensures no resource provider registrations are performed by Terraform
  resource_provider_registrations = "none"

  # Update this subscription_id value to match your Azure subscription
  subscription_id = "00000000-0000-0000-0000-000000000000"

  # This is a required block which contains any advanced configuration options you may need - don't worry worry about it for now
  features {}
}
