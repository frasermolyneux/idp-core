environment = "dev"
location    = "swedencentral"
instance    = "01"

subscription_id = "6cad03c1-9e98-4160-8ebe-64dd30f1bbc7"

platform_workloads_state = {
  resource_group_name  = "rg-tf-platform-workloads-prd-uksouth-01"
  storage_account_name = "sadz9ita659lj9xb3"
  container_name       = "tfstate"
  key                  = "terraform.tfstate"
  subscription_id      = "7760848c-794d-4a19-8cb2-52f71a21ac2b"
  tenant_id            = "e56a6947-bb9a-4a6e-846a-1f118d1c3a14"
}

platform_monitoring_state = {
  resource_group_name  = "rg-tf-platform-monitoring-dev-uksouth-01"
  storage_account_name = "sa9d99036f14d5"
  container_name       = "tfstate"
  key                  = "terraform.tfstate"
  subscription_id      = "7760848c-794d-4a19-8cb2-52f71a21ac2b"
  tenant_id            = "e56a6947-bb9a-4a6e-846a-1f118d1c3a14"
}

target_subscriptions = {
  sub-visualstudio-enterprise        = "6cad03c1-9e98-4160-8ebe-64dd30f1bbc7"
  sub-visualstudio-enterprise-legacy = "d68448b0-9947-46d7-8771-baa331a3063a"
  sub-platform-connectivity          = "db34f572-8b71-40d6-8f99-f29a27612144"
  sub-platform-identity              = "c391a150-f992-41a6-bc81-ebc22bc64376"
  sub-platform-management            = "7760848c-794d-4a19-8cb2-52f71a21ac2b"
  sub-platform-shared                = "903b6685-c12a-4703-ac54-7ec1ff15ca43"
  sub-enterprise-devtest-legacy      = "1b5b28ed-1365-4a48-b285-80f80a6aaa1b"
  sub-fm-geolocation-prd             = "d3b204ab-7c2b-47f7-8d5a-de19e85591e7"
  sub-mx-consulting-prd              = "655da25d-da46-40c0-8e81-5debe2dcd024"
  sub-talkwithtiles-prd              = "e1e5de62-3573-4b44-a52b-0f1431675929"
  sub-xi-demomanager-prd             = "845766d6-b73f-49aa-a9f6-eaf27e20b7a8"
  sub-xi-portal-prd                  = "32444f38-32f4-409f-889c-8e8aa2b5b4d1"
  sub-finances-prd                   = "957a7d34-8562-4098-bb4c-072e08386d07"
  sub-molyneux-me-dev                = "ef3cc6c2-159e-4890-9193-13673dded835"
  sub-molyneux-me-prd                = "3cc59319-eb1e-4b52-b19e-09a49f9db2e7"
}
