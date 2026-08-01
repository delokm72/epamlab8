resource "azurerm_container_registry" "acr" {
  location            = var.location
  name                = var.acr_name
  resource_group_name = var.rg_name
  sku                 = var.acr_sku
  # Enable the built-in admin account.
  # ACI uses image_registry_credential to pull images from ACR.
  # This account provides the username and password required for authentication.
  admin_enabled = true
}

resource "azurerm_container_registry_task" "task" {
  name                  = var.task_name
  container_registry_id = azurerm_container_registry.acr.id
  platform {
    os = "Linux"
  }
  docker_step {
    context_path    = var.context_path
    dockerfile_path = var.dockerfile_path
    image_names     = ["${var.docker_image_name}:latest"]
    # Git Personal Access Token
    context_access_token = var.git_pat != "" ? var.git_pat : null
  }
}

resource "azurerm_container_registry_task_schedule_run_now" "schedule" {
  container_registry_task_id = azurerm_container_registry_task.task.id
}
