resource "azurerm_cosmosdb_account" "idp" {
  name                = format("cosmos-%s", local.resource_prefix)
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  free_tier_enabled = true

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = data.azurerm_resource_group.rg.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "idp" {
  name                = "idp"
  resource_group_name = azurerm_cosmosdb_account.idp.resource_group_name
  account_name        = azurerm_cosmosdb_account.idp.name
  throughput          = 1000
}

resource "azurerm_cosmosdb_sql_container" "conversations" {
  name                = "conversations"
  resource_group_name = azurerm_cosmosdb_account.idp.resource_group_name
  account_name        = azurerm_cosmosdb_account.idp.name
  database_name       = azurerm_cosmosdb_sql_database.idp.name
  partition_key_paths = ["/userId"]
}

resource "azurerm_cosmosdb_sql_container" "messages" {
  name                = "messages"
  resource_group_name = azurerm_cosmosdb_account.idp.resource_group_name
  account_name        = azurerm_cosmosdb_account.idp.name
  database_name       = azurerm_cosmosdb_sql_database.idp.name
  partition_key_paths = ["/conversationId"]
}

resource "azurerm_cosmosdb_sql_container" "campaigns" {
  name                = "campaigns"
  resource_group_name = azurerm_cosmosdb_account.idp.resource_group_name
  account_name        = azurerm_cosmosdb_account.idp.name
  database_name       = azurerm_cosmosdb_sql_database.idp.name
  partition_key_paths = ["/userId"]
}
