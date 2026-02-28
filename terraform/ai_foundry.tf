resource "azurerm_storage_account" "ai" {
  name                     = format("staidp%s%s", var.environment, random_id.storage.hex)
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_cognitive_account" "openai" {
  name                  = format("oai-%s", local.resource_prefix)
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = data.azurerm_resource_group.rg.location
  kind                  = "OpenAI"
  sku_name              = "S0"
  custom_subdomain_name = format("oai-%s", local.resource_prefix)
}

resource "azapi_resource" "ai_hub" {
  type      = "Microsoft.MachineLearningServices/workspaces@2024-10-01"
  name      = format("aih-%s", local.resource_prefix)
  location  = data.azurerm_resource_group.rg.location
  parent_id = data.azurerm_resource_group.rg.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.idp_agents.id]
  }

  body = {
    kind = "Hub"
    properties = {
      friendlyName                = format("aih-%s", local.resource_prefix)
      storageAccount              = azurerm_storage_account.ai.id
      keyVault                    = azurerm_key_vault.kv.id
      applicationInsights         = azurerm_application_insights.ai.id
      primaryUserAssignedIdentity = azurerm_user_assigned_identity.idp_agents.id
    }
    sku = {
      name = "Basic"
      tier = "Basic"
    }
  }

  response_export_values = ["properties.discoveryUrl"]
}

resource "azapi_resource" "ai_project" {
  type      = "Microsoft.MachineLearningServices/workspaces@2024-10-01"
  name      = format("aip-%s", local.resource_prefix)
  location  = data.azurerm_resource_group.rg.location
  parent_id = data.azurerm_resource_group.rg.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.idp_agents.id]
  }

  body = {
    kind = "Project"
    properties = {
      friendlyName  = format("aip-%s", local.resource_prefix)
      hubResourceId = azapi_resource.ai_hub.id
    }
    sku = {
      name = "Basic"
      tier = "Basic"
    }
  }

  response_export_values = ["properties.discoveryUrl"]
}

resource "azapi_resource" "ai_hub_openai_connection" {
  type      = "Microsoft.MachineLearningServices/workspaces/connections@2024-10-01"
  name      = "openai"
  parent_id = azapi_resource.ai_hub.id

  body = {
    properties = {
      category      = "AzureOpenAI"
      target        = azurerm_cognitive_account.openai.endpoint
      authType      = "AAD"
      isSharedToAll = true
      metadata = {
        ApiType    = "Azure"
        ResourceId = azurerm_cognitive_account.openai.id
      }
    }
  }
}

resource "azapi_resource" "deploy_gpt_5_mini" {
  type      = "Microsoft.CognitiveServices/accounts/deployments@2024-10-01"
  name      = "gpt-5-mini"
  parent_id = azurerm_cognitive_account.openai.id

  body = {
    sku = {
      name     = "Standard"
      capacity = 30
    }
    properties = {
      model = {
        format  = "OpenAI"
        name    = "gpt-5-mini"
        version = "2025-01-31"
      }
    }
  }
}

resource "azapi_resource" "deploy_gpt_5_1" {
  type      = "Microsoft.CognitiveServices/accounts/deployments@2024-10-01"
  name      = "gpt-5-1"
  parent_id = azurerm_cognitive_account.openai.id

  body = {
    sku = {
      name     = "Standard"
      capacity = 10
    }
    properties = {
      model = {
        format  = "OpenAI"
        name    = "gpt-5.1"
        version = "2025-04-14"
      }
    }
  }

  depends_on = [azapi_resource.deploy_gpt_5_mini]
}

resource "azapi_resource" "deploy_text_3_small" {
  type      = "Microsoft.CognitiveServices/accounts/deployments@2024-10-01"
  name      = "text-3-small"
  parent_id = azurerm_cognitive_account.openai.id

  body = {
    sku = {
      name     = "Standard"
      capacity = 10
    }
    properties = {
      model = {
        format  = "OpenAI"
        name    = "text-3-small"
        version = "1"
      }
    }
  }

  depends_on = [azapi_resource.deploy_gpt_5_1]
}
