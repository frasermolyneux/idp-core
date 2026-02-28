# Key Vault role assignments
resource "azurerm_role_assignment" "web_kv_secrets_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.idp_web.principal_id
}

resource "azurerm_role_assignment" "agents_kv_secrets_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.idp_agents.principal_id
}

# Cosmos DB role assignments (built-in Data Contributor: 00000000-0000-0000-0000-000000000002)
resource "azurerm_cosmosdb_sql_role_assignment" "web_cosmos_contributor" {
  resource_group_name = azurerm_cosmosdb_account.idp.resource_group_name
  account_name        = azurerm_cosmosdb_account.idp.name
  role_definition_id  = "${azurerm_cosmosdb_account.idp.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = azurerm_user_assigned_identity.idp_web.principal_id
  scope               = azurerm_cosmosdb_account.idp.id
}

resource "azurerm_cosmosdb_sql_role_assignment" "agents_cosmos_contributor" {
  resource_group_name = azurerm_cosmosdb_account.idp.resource_group_name
  account_name        = azurerm_cosmosdb_account.idp.name
  role_definition_id  = "${azurerm_cosmosdb_account.idp.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = azurerm_user_assigned_identity.idp_agents.principal_id
  scope               = azurerm_cosmosdb_account.idp.id
}

# AI Foundry role assignments
resource "azurerm_role_assignment" "agents_ai_hub_openai_user" {
  scope                = azurerm_cognitive_account.openai.id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = azurerm_user_assigned_identity.idp_agents.principal_id
}

# AI Search role assignments
resource "azurerm_role_assignment" "agents_search_data_reader" {
  scope                = azurerm_search_service.idp.id
  role_definition_name = "Search Index Data Reader"
  principal_id         = azurerm_user_assigned_identity.idp_agents.principal_id
}

resource "azurerm_role_assignment" "agents_search_data_contributor" {
  scope                = azurerm_search_service.idp.id
  role_definition_name = "Search Index Data Contributor"
  principal_id         = azurerm_user_assigned_identity.idp_agents.principal_id
}

# Subscription-level role assignments for IDP agents MI
# Uses subscriptions output from platform-workloads remote state
resource "azurerm_role_assignment" "agents_subscription_reader" {
  for_each             = data.terraform_remote_state.platform_workloads.outputs.subscriptions
  scope                = "/subscriptions/${each.value.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.idp_agents.principal_id
}

resource "azurerm_role_assignment" "agents_subscription_cost_reader" {
  for_each             = data.terraform_remote_state.platform_workloads.outputs.subscriptions
  scope                = "/subscriptions/${each.value.subscription_id}"
  role_definition_name = "Cost Management Reader"
  principal_id         = azurerm_user_assigned_identity.idp_agents.principal_id
}
