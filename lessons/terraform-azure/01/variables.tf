variable "resource_group_name" {
  description = "The name of the resource group to create"
  type        = string
}

variable "location" {
  description = "The Azure region to create resources in"
  type        = string
}

variable "subscription_id" {
  description = "The Azure subscription ID to use for authentication"
  type        = string
}
