output "resource_group_name" {
  value = data.azurerm_resource_group.rg.name
}

# Cosmos DB
output "cosmosdb_endpoint" {
  value = azurerm_cosmosdb_account.idp.endpoint
}

output "cosmosdb_database_name" {
  value = azurerm_cosmosdb_sql_database.idp.name
}

# Key Vault
output "key_vault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}

# AI Foundry
output "ai_hub_id" {
  value = azapi_resource.ai_hub.id
}

output "ai_hub_discovery_url" {
  value = azapi_resource.ai_hub.output.properties.discoveryUrl
}

output "ai_project_id" {
  value = azapi_resource.ai_project.id
}

output "ai_project_discovery_url" {
  value = azapi_resource.ai_project.output.properties.discoveryUrl
}

output "openai_endpoint" {
  value = azurerm_cognitive_account.openai.endpoint
}

# AI Search
output "ai_search_endpoint" {
  value = "https://${azurerm_search_service.idp.name}.search.windows.net"
}

output "ai_search_name" {
  value = azurerm_search_service.idp.name
}

# Redis
output "redis_hostname" {
  value = azurerm_redis_cache.idp.hostname
}

output "redis_ssl_port" {
  value = azurerm_redis_cache.idp.ssl_port
}

# Application Insights
output "app_insights_instrumentation_key" {
  value     = azurerm_application_insights.ai.instrumentation_key
  sensitive = true
}

output "app_insights_connection_string" {
  value     = azurerm_application_insights.ai.connection_string
  sensitive = true
}

# Managed Identities - Web
output "idp_web_mi_id" {
  value = azurerm_user_assigned_identity.idp_web.id
}

output "idp_web_mi_client_id" {
  value = azurerm_user_assigned_identity.idp_web.client_id
}

output "idp_web_mi_principal_id" {
  value = azurerm_user_assigned_identity.idp_web.principal_id
}

# Managed Identities - Agents
output "idp_agents_mi_id" {
  value = azurerm_user_assigned_identity.idp_agents.id
}

output "idp_agents_mi_client_id" {
  value = azurerm_user_assigned_identity.idp_agents.client_id
}

output "idp_agents_mi_principal_id" {
  value = azurerm_user_assigned_identity.idp_agents.principal_id
}

# App Registration Client IDs
output "idp_web_app_client_id" {
  value = azuread_application.idp.client_id
}

output "idp_agents_app_client_id" {
  value = azuread_application.idp_agents.client_id
}

# OBO Client Secret Key Vault Reference
output "idp_obo_client_secret_uri" {
  value = azurerm_key_vault_secret.idp_client_secret.versionless_id
}

# GitHub App
output "github_app_id" {
  value = var.github_app_id
}

output "github_app_installation_id" {
  value = var.github_app_installation_id
}

output "github_app_pem_secret_name" {
  value = "github-app-private-key"
}

# Durable Task Scheduler
output "dts_endpoint" {
  value = azapi_resource.dts.output.properties.endpoint
}

output "dts_task_hub_name" {
  value = azapi_resource.dts_task_hub.name
}
