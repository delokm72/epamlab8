output "acr_login_server" {
  description = "..."
  value       = azurerm_container_registry.acr.login_server
}

output "id" {
  description = "..."
  value       = azurerm_container_registry.acr.id
}

output "image" {
  description = "..."
  # потрібно саме імедж повний шлях а не імя!
  value = "${azurerm_container_registry.acr.login_server}/${var.docker_image_name}:latest"
}
# існує тільки коли admin_enabled = true
output "admin_username" {
  value = azurerm_container_registry.acr.admin_username
}
# існує тільки коли admin_enabled = true
output "admin_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}