resource "azurerm_storage_account" "ai" {
  name                     = format("staidp%s%s", var.environment, random_id.storage.hex)
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Microsoft Foundry (upgraded from Azure OpenAI — kind AIServices)
resource "azurerm_ai_services" "openai" {
  name                  = format("oai-%s", local.resource_prefix)
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = data.azurerm_resource_group.rg.location
  sku_name              = "S0"
  custom_subdomain_name = format("oai-%s", local.resource_prefix)
}

resource "azurerm_ai_foundry" "hub" {
  name                = format("aih-%s", local.resource_prefix)
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  storage_account_id  = azurerm_storage_account.ai.id
  key_vault_id        = azurerm_key_vault.kv.id

  application_insights_id        = azurerm_application_insights.ai.id
  friendly_name                  = format("aih-%s", local.resource_prefix)
  primary_user_assigned_identity = azurerm_user_assigned_identity.idp_agents.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.idp_agents.id]
  }
}

resource "azurerm_ai_foundry_project" "project" {
  name               = format("aip-%s", local.resource_prefix)
  location           = azurerm_ai_foundry.hub.location
  ai_services_hub_id = azurerm_ai_foundry.hub.id
  friendly_name      = format("aip-%s", local.resource_prefix)

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.idp_agents.id]
  }
}

resource "azapi_resource" "ai_hub_openai_connection" {
  type      = "Microsoft.MachineLearningServices/workspaces/connections@2024-10-01"
  name      = "openai"
  parent_id = azurerm_ai_foundry.hub.id

  body = {
    properties = {
      category      = "AzureOpenAI"
      target        = azurerm_ai_services.openai.endpoint
      authType      = "AAD"
      isSharedToAll = true
      metadata = {
        ApiType    = "Azure"
        ResourceId = azurerm_ai_services.openai.id
      }
    }
  }
}

# Model deployments — update model names/versions after checking availability:
#   az cognitiveservices account list-models --name <account> --resource-group <rg>
resource "azurerm_cognitive_deployment" "chat_model" {
  name                 = var.chat_model_deployment_name
  cognitive_account_id = azurerm_ai_services.openai.id

  model {
    format  = "OpenAI"
    name    = var.chat_model_name
    version = var.chat_model_version
  }

  sku {
    name     = "Standard"
    capacity = 30
  }
}

resource "azurerm_cognitive_deployment" "reasoning_model" {
  name                 = var.reasoning_model_deployment_name
  cognitive_account_id = azurerm_ai_services.openai.id

  model {
    format  = "OpenAI"
    name    = var.reasoning_model_name
    version = var.reasoning_model_version
  }

  sku {
    name     = "Standard"
    capacity = 10
  }

  depends_on = [azurerm_cognitive_deployment.chat_model]
}

resource "azurerm_cognitive_deployment" "embedding_model" {
  name                 = var.embedding_model_deployment_name
  cognitive_account_id = azurerm_ai_services.openai.id

  model {
    format  = "OpenAI"
    name    = var.embedding_model_name
    version = var.embedding_model_version
  }

  sku {
    name     = "GlobalStandard"
    capacity = 10
  }

  depends_on = [azurerm_cognitive_deployment.reasoning_model]
}
