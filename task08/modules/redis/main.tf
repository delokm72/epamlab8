# Redis не потрібен Terraform після створення.
# Він потрібен застосунку, який працює всередині контейнера.
resource "azurerm_redis_cache" "redis" {
  capacity            = var.capacity
  family              = var.family
  location            = var.location
  name                = var.name
  resource_group_name = var.rg_name
  sku_name            = var.sku
  tags                = var.tags
}

resource "azurerm_key_vault_secret" "stored_redis_hostname" {
  name         = var.secret_hostname
  # генерується в редіс і записується тут
  value        = azurerm_redis_cache.redis.hostname
  key_vault_id = var.key_vault_id
  depends_on = [
    var.kv_policy_id
  ]
}

resource "azurerm_key_vault_secret" "stored_redis_access_key" {
  name         = var.secret_key
  # генерується в редіс і записується тут
  value        = azurerm_redis_cache.redis.primary_access_key
  key_vault_id = var.key_vault_id
  depends_on = [
    # це по суті azurerm_key_vault_access_policy.kv_policy.id
    var.kv_policy_id
  ]
}