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

# Model deployment variables — check available models with:
#   az cognitiveservices account list-models --name <account> --resource-group <rg>
variable "chat_model_name" {
  type    = string
  default = "gpt-4.1-mini"
}

variable "chat_model_version" {
  type    = string
  default = null
}

variable "chat_model_deployment_name" {
  type    = string
  default = "gpt-4.1-mini"
}

variable "reasoning_model_name" {
  type    = string
  default = "gpt-5.1-chat"
}

variable "reasoning_model_version" {
  type    = string
  default = null
}

variable "reasoning_model_deployment_name" {
  type    = string
  default = "gpt-5.1-chat"
}

variable "embedding_model_name" {
  type    = string
  default = "text-embedding-3-small"
}

variable "embedding_model_version" {
  type    = string
  default = null
}

variable "embedding_model_deployment_name" {
  type    = string
  default = "text-embedding-3-small"
}
