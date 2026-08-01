# Kubernetes API server endpoint.
output "host" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].host
}

# Base64 encoded CA certificate used to verify the cluster.
output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate
  sensitive = true
}

# Base64 encoded client certificate.
output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
  sensitive = true
}

# Base64 encoded client private key.
output "client_key" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].client_key
  sensitive = true
}

output "kv_secret_identity_client_id" {
  value = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].client_id
}

output "aks_debug" {
  value     = azurerm_kubernetes_cluster.aks
  sensitive = true
}

