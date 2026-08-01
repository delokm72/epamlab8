output "id" {
  description = "..."
  value       = azurerm_key_vault.kv.id
}

output "kv_name" {
  description = "..."
  value       = azurerm_key_vault.kv.name
}

output "tenant_id" {
  description = "..."
  value       = data.azurerm_client_config.current.tenant_id
}

output "policy_id" {
  value = azurerm_key_vault_access_policy.kv_policy.id
}