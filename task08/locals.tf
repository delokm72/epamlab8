locals {
  prefix         = "cmtr-53z813ye-mod8"
  redis_name     = "${local.prefix}-redis"
  rg_name        = "${local.prefix}-rg"
  akv_name       = "${local.prefix}-kv"
  acr_image_name = "${local.prefix}-app"
  aci_name       = "${local.prefix}-ci"
  aks_name       = "${local.prefix}-aks"

  acr_name = "cmtr53z813yemod8cr"
}
