resource "azurerm_storage_account" "knowledge" {
  name                     = format("stknidp%s%s", var.environment, random_id.storage.hex)
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_storage_container" "knowledge_docs" {
  name                  = "knowledge-docs"
  storage_account_id    = azurerm_storage_account.knowledge.id
  container_access_type = "private"
}
