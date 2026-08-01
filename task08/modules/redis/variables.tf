variable "key_vault_id" {
  type        = string
  description = "..."
}

variable "secret_hostname" {
  type        = string
  description = "..."
}

variable "secret_key" {
  type        = string
  description = "..."
}

variable "family" {
  type        = string
  description = "..."
}

variable "location" {
  type        = string
  description = "..."
}

variable "capacity" {
  type        = string
  description = "..."
}

variable "rg_name" {
  type        = string
  description = "..."
}

variable "sku" {
  type        = string
  description = "..."
}

variable "name" {
  type        = string
  description = "..."
}

variable "tags" {
  description = "Tags applied to all Azure resources"
  type        = map(string)
}