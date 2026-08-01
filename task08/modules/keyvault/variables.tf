variable "name" {
  type        = string
  description = "..."
}

variable "resource_group_name" {
  type        = string
  description = "..."
}

variable "location" {
  type        = string
  description = "..."
}

variable "sku_name" {
  type        = string
  description = "..."
}

variable "tags" {
  description = "Tags applied to all Azure resources"
  type        = map(string)
}