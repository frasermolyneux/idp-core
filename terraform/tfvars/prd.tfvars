environment = "prd"
location    = "swedencentral"
instance    = "01"

subscription_id = "903b6685-c12a-4703-ac54-7ec1ff15ca43"

platform_workloads_state = {
  resource_group_name  = "rg-tf-platform-workloads-prd-uksouth-01"
  storage_account_name = "sadz9ita659lj9xb3"
  container_name       = "tfstate"
  key                  = "terraform.tfstate"
}

platform_monitoring_state = {
  resource_group_name  = "rg-tf-platform-monitoring-prd-uksouth-01"
  storage_account_name = "sa74f04c5f984e"
  container_name       = "tfstate"
  key                  = "terraform.tfstate"
}
