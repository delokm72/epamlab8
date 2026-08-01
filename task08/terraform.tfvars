tags = {
  Creator = "oleksandr_muravskyi@epam.com"
}
redis_capacity                = 2
redis_sku                     = "Basic"
redis_sku_family              = "C"
kv_sku                        = "standard"
redis_primary_key_secret_name = "redis-primary-key"
redis_secret_hostname         = "redis-hostname"
acr_sku                       = "Standard"
aci_sku                       = "Standard"
aks_size                      = "Standard_D2ads_v6"
location                      = "East US"

acr_context_path    = "https://github.com/delokm72/epamlab8.git#master:task08/application"
acr_dockerfile_path = "Dockerfile"
