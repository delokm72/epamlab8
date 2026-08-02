locals {
  name_prefix    = "cmtr-53z813ye-mod8"
  redis_name     = "${local.name_prefix}-redis"
  rg_name        = "${local.name_prefix}-rg"
  keyvault_name  = "${local.name_prefix}-kv"
  acr_image_name = "${local.name_prefix}-app"
  aci_name       = "${local.name_prefix}-ci"
  aks_name       = "${local.name_prefix}-aks"

  acr_name = "cmtr53z813yemod8cr"
}
