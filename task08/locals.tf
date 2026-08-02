locals {
  redis_name     = "${var.name_prefix}-redis"
  rg_name        = "${var.name_prefix}-rg"
  keyvault_name  = "${var.name_prefix}-kv"
  acr_image_name = "${var.name_prefix}-app"
  aci_name       = "${var.name_prefix}-ci"
  aks_name       = "${var.name_prefix}-aks"
  acr_name       = "cmtr53z813yemod8cr"
}
