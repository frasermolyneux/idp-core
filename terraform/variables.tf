variable "workload_name" {
  default = "idp-core"
}

variable "environment" {
  type = string
}

variable "location" {
  type    = string
  default = "swedencentral"
}

variable "instance" {
  type    = string
  default = "01"
}

variable "subscription_id" {
  type = string
}

variable "platform_workloads_state" {
  type = object({
    resource_group_name  = string
    storage_account_name = string
    container_name       = string
    key                  = string
    subscription_id      = string
    tenant_id            = string
  })
}

variable "platform_monitoring_state" {
  type = object({
    resource_group_name  = string
    storage_account_name = string
    container_name       = string
    key                  = string
    subscription_id      = string
    tenant_id            = string
  })
}

variable "github_app_id" {
  type    = string
  default = "2973523"
}

variable "github_app_installation_id" {
  type    = string
  default = "113093932"
}
