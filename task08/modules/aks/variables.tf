variable "rg_name" {
  type        = string
  description = "..."
}

variable "location" {
  type        = string
  description = "..."
}

variable "name" {
  type        = string
  description = "..."
}

variable "os_disk_type" {
  type        = string
  description = "..."
  default     = "Ephemeral"
}

variable "node_size" {
  type        = string
  description = "..."
  default     = "Standard_D2ads_v6"
}

variable "instance_count" {
  type        = number
  description = "..."
  default     = 1
}

variable "node_pool_name" {
  type        = string
  description = "..."
  default     = "system"
}

variable "acr_id" {
  type        = string
  description = "..."
  default     = "system"
}

variable "key_vault_id" {
  type        = string
  description = "..."
  default     = "system"
}