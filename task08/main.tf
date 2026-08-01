resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

module "keyvault" {
  source              = "./modules/keyvault"
  location            = var.location
  name                = local.akv_name
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = var.kv_sku
  tags                = var.tags
}

module "redis" {
  source          = "./modules/redis"
  key_vault_id    = module.keyvault.id
  secret_hostname = var.redis_secret_hostname
  secret_key      = var.redis_primary_key_secret_name
  capacity        = var.redis_capacity
  family          = var.redis_sku_family
  location        = azurerm_resource_group.rg.location
  name            = local.redis_name
  rg_name         = azurerm_resource_group.rg.name
  sku             = var.redis_sku
  tags            = var.tags
}

module "acr" {
  source            = "./modules/acr"
  acr_name          = local.acr_name
  acr_sku           = var.acr_sku
  context_path      = var.acr_context_path
  docker_image_name = local.acr_image_name
  dockerfile_path   = var.acr_dockerfile_path
  git_pat           = var.git_pat
  location          = azurerm_resource_group.rg.location
  rg_name           = azurerm_resource_group.rg.name
  tags              = var.tags
}

module "aks" {
  source       = "./modules/aks"
  acr_id       = module.acr.id
  key_vault_id = module.keyvault.id
  location     = azurerm_resource_group.rg.location
  name         = local.aks_name
  rg_name      = azurerm_resource_group.rg.name
}
# Read Redis hostname from Key Vault.
# The secret was created by the Redis module.
data "azurerm_key_vault_secret" "redis_hostname" {
  name         = var.redis_secret_hostname
  key_vault_id = module.keyvault.id
}
# Read Redis primary access key from Key Vault.
# The secret was created by the Redis module.
data "azurerm_key_vault_secret" "redis_primary_key" {
  name         = var.redis_primary_key_secret_name
  key_vault_id = module.keyvault.id
}

module "aci" {
  source            = "./modules/aci"
  location          = azurerm_resource_group.rg.location
  name              = local.aci_name
  rg_name           = azurerm_resource_group.rg.name
  image             = module.acr.image
  redis_url         = data.azurerm_key_vault_secret.redis_hostname.value
  redis_password    = data.azurerm_key_vault_secret.redis_primary_key.value
  registry_server   = module.acr.acr_login_server
  registry_username = module.acr.admin_username
  registry_password = module.acr.admin_password
}
# опиано в versions.tf
provider "kubectl" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  # "Не використовуй локальний ~/.kube/config. Використовуй параметри, які явно передані в provider."
  load_config_file = false
}

# Create SecretProviderClass in Kubernetes.
# It configures the Secrets Store CSI Driver to read secrets
# directly from Azure Key Vault and automatically create
# a Kubernetes Secret (redis-secrets) for application Pods.
resource "kubectl_manifest" "secret_provider" {
  yaml_body = templatefile(
    "${path.module}/k8s-manifests/secret-provider.yaml.tftpl",
    {
      # передаємо значення всіх змінних які є в файлі, їх формат ${
      aks_kv_access_identity_id  = module.aks.kv_secret_identity_client_id
      kv_name                    = local.akv_name
      redis_url_secret_name      = data.azurerm_key_vault_secret.redis_hostname.value
      redis_password_secret_name = data.azurerm_key_vault_secret.redis_primary_key.value
      tenant_id                  = module.keyvault.tenant_id
    }
  )
}

# Create Kubernetes Deployment for the application.
# Kubernetes pulls the Docker image from Azure Container Registry (ACR),
# creates Pods and keeps the requested number of replicas running.
# Redis connection settings are provided through Kubernetes Secrets.
resource "kubectl_manifest" "deployment" {
  yaml_body = templatefile(
    # передаємо значення всіх змінних які є в файлі, їх формат ${
    "${path.module}/k8s-manifests/deployment.yaml.tftpl",
    {
      acr_login_server = module.acr.acr_login_server
      app_image_name   = local.acr_image_name
      image_tag        = "latest"
    }
  )
  depends_on = [
    kubectl_manifest.secret_provider
  ]
  wait_for {
    field {
      key   = "status.availableReplicas"
      value = "1"
    }
  }
}

# Create Kubernetes Service of type LoadBalancer.
# Exposes the application to the Internet through an Azure Load Balancer
# and routes incoming traffic to the application Pods.
resource "kubectl_manifest" "service" {
  yaml_body = file("${path.module}/k8s-manifests/service.yaml")
  depends_on = [
    kubectl_manifest.deployment
  ]
  wait_for {
    field {
      key        = "status.loadBalancer.ingress.[0].ip"
      value      = "^(\\d+(\\.|$)){4}"
      value_type = "regex"
    }
  }
}
