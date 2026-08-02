# Azure Container Instance (ACI) один із способів запуска образів в ажур
# Цей коли потрібно просто запустити контейнер. Ніякого Kubernetes, Pod'ів чи масштабування.
resource "azurerm_container_group" "container" {
  image_registry_credential {
    server   = var.registry_server
    username = var.registry_username
    password = var.registry_password
  }
  dns_name_label      = var.name
  ip_address_type     = "Public"
  location            = var.location
  name                = var.name
  os_type             = var.os_type
  resource_group_name = var.rg_name
  container {
    # використовувати імя групи тільки тоді коли контейнер 1 всередині групи!
    name = var.name
    # параметри память і проц вибрані просто так в задачі немає вимог
    cpu    = 1
    memory = 1.5
    # AKS не отримує імедж а тільки створює інфраструктуру а в ній вже буде додано зміст
    # використовуючи папку k8s-manifests і інструкції в головному файлі
    # тут спосіб простий тому є зразу імедж
    image = var.image
    # Port exposed by the application inside the container.
    # Must match the EXPOSE instruction in the Dockerfile.
    ports {
      port     = 8080
      protocol = "TCP"
    }
    # Це змінні середовища, які читає app.py
    environment_variables = {
      CREATOR        = "ACI"
      REDIS_PORT     = "6380"
      REDIS_SSL_MODE = "True"
    }
    secure_environment_variables = {
      REDIS_URL = var.redis_url
      REDIS_PWD = var.redis_password
    }
  }
  tags = var.tags
}
