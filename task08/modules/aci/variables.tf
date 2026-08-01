variable "location" {
  type        = string
  description = "..."
}

variable "name" {
  type        = string
  description = "..."
}

variable "os_type" {
  type        = string
  description = "..."
  default     = "Linux"
}

variable "rg_name" {
  type        = string
  description = "..."
}

variable "image" {
  type        = string
  description = "..."
}

variable "redis_url" {
  type        = string
  description = "..."
}

variable "redis_password" {
  type        = string
  description = "..."
}

variable "registry_server" {
  type        = string
  description = "..."
}

variable "registry_username" {
  type        = string
  description = "..."
}

variable "registry_password" {
  type        = string
  description = "..."
}