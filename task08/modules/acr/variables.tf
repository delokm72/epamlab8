variable "rg_name" {
  type        = string
  description = "..."
}

variable "acr_name" {
  type        = string
  description = "..."
}
# 5 length min!
variable "task_name" {
  type        = string
  description = "..."
  default     = "Omur1"
}

variable "tags" {
  description = "Tags applied to all Azure resources"
  type        = map(string)
}

variable "location" {
  type        = string
  description = "..."
}

variable "acr_sku" {
  type        = string
  description = "..."
}

variable "docker_image_name" {
  type        = string
  description = "..."
}

variable "git_pat" {
  type        = string
  description = "..."
  sensitive   = true
}

variable "context_path" {
  type        = string
  description = "..."
}

variable "dockerfile_path" {
  type        = string
  description = "..."
}



