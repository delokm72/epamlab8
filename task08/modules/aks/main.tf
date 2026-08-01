# Information about the currently authenticated Azure client.
# Used to obtain Tenant ID for Azure Key Vault access policy.
data "azurerm_client_config" "current" {}

# Azure Kubernetes Service (AKS) один із способів запуска образів в ажур, більш просунутий за ACI
# Це вже коли застосунок має працювати постійно.
# Є балансування, масштабування, і тд
# ACI просто запускає контейнер. AKS запускає той самий контейнер, але ще може масштабувати його,
# перезапускати після збоїв, балансувати навантаження, виконувати rolling update та багато іншого.
resource "azurerm_kubernetes_cluster" "aks" {
  location            = var.location
  name                = var.name
  resource_group_name = var.rg_name
  dns_prefix          = var.name
  default_node_pool {
    name         = var.node_pool_name
    node_count   = var.instance_count
    vm_size      = var.node_size
    os_disk_type = var.os_disk_type
    # Explicitly set the OS disk size.
    # Azure defaults to 128 GB, which causes validation issues
    # for some VM sizes with Ephemeral OS disks.
    os_disk_size_gb = 30
  }
  # видаляється разом з ресурсом, може бути UserAssigned але задача цього не просить)
  identity {
    type = "SystemAssigned"
  }
  # Секрети читаються напряму з Azure Key Vault через Managed Identity
  key_vault_secrets_provider {
    # Це дозволяє драйверу автоматично оновлювати секрети, якщо вони зміняться в Key Vault.
    secret_rotation_enabled = true
  }
}

# Дати AKS право читати ACR
resource "azurerm_role_assignment" "assigment" {
  # хто отримує доступ
  # !!! Це Object ID об'єкта Azure Active Directory (Microsoft Entra ID), якому видаються права.
  # Kubelet відповідає за запуск контейнерів на вузлах AKS і саме він
  # завантажує Docker-образи з Azure Container Registry (ACR).
  #
  # Identity створюється Azure автоматично після створення кластера,
  # оскільки в azurerm_kubernetes_cluster використано:
  #
  # identity {
  #   type = "SystemAssigned"
  # }
  #
  # Terraform отримує її Object ID з атрибутів створеного AKS.
  principal_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  # для чого
  # Azure Resource ID контейнерного реєстру, до якого видаються права.
  # Передається з модуля Azure Container Registry (ACR).
  scope = var.acr_id
  # і яку саме роль
  # Вбудована роль Azure, що дозволяє завантажувати (pull) Docker-образи.
  role_definition_name = "AcrPull"
}

# Дати AKS право читати Key Vault
resource "azurerm_key_vault_access_policy" "ask_policy" {
  # Azure Resource ID Key Vault.
  # До цього Key Vault буде додано політику доступу.
  # Передається з модуля Key Vault через output "id".
  key_vault_id = var.key_vault_id
  # Secrets Store CSI Driver використовує цю identity
  # для читання секретів з Azure Key Vault.
  # Identity створюється Azure автоматично разом із кластером,
  # тому Terraform отримує її зі створеного ресурсу AKS.
  # значення ідентичне principal_id в "assigment"
  object_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  # Microsoft Entra ID (Azure Active Directory) Tenant ID.
  # Determines in which tenant the Managed Identity exists.
  # Obtained from the currently authenticated Azure account.
  tenant_id = data.azurerm_client_config.current.tenant_id
}
