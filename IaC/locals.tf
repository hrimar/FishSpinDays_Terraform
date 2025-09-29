locals {
  env          = "prod"
  location     = var.location
  region_code  = "ne"
  rg_name      = "fishspindays-${local.env}-${local.region_code}-rg"
  plan_name    = "fishspindays-${local.env}-${local.region_code}-plan"
  app_name     = "fishspindays-${local.env}-${local.region_code}-app"
  sql_name     = "fishspindays-${local.env}-${local.region_code}-sql"
  db_name      = "fishspindays-${local.env}-${local.region_code}-db"
  kv_name      = "fishspindays-${local.env}-${local.region_code}-kv"
  signalr_name = "fishspindays-${local.env}-${local.region_code}-signalr"
  tags = {
    environment = local.env
    project     = "FishSpinDays"
    owner       = "hhristoff@yahoo.com"
  }
}