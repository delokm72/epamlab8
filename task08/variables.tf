variable "tags" {
  description = "Tags applied to all Azure resources"
  type        = map(string)
}

variable "redis_capacity" {
  description = "..."
  type        = number
}

variable "redis_sku" {
  description = "..."
  type        = string
}

variable "redis_sku_family" {
  description = "..."
  type        = string
}

variable "kv_sku" {
  description = "..."
  type        = string
}

variable "redis_primary_key_secret_name" {
  description = "..."
  type        = string
}

variable "redis_secret_hostname" {
  description = "..."
  type        = string
}

variable "acr_sku" {
  description = "..."
  type        = string
}

variable "aci_sku" {
  description = "..."
  type        = string
}

variable "aks_size" {
  description = "..."
  type        = string
}

variable "location" {
  description = "..."
  type        = string
}

variable "acr_context_path" {
  description = "..."
  type        = string
}

variable "acr_dockerfile_path" {
  description = "..."
  type        = string
}

variable "git_pat" {
  type      = string
  sensitive = true
}
