resource "azapi_resource" "dts" {
  type      = "Microsoft.DurableTask/schedulers@2025-04-01-preview"
  name      = format("dts-%s", local.resource_prefix)
  location  = data.azurerm_resource_group.rg.location
  parent_id = data.azurerm_resource_group.rg.id

  body = {
    properties = {
      sku = {
        name = "Consumption"
      }
      ipAllowlist = []
    }
  }

  response_export_values = ["properties.endpoint"]
}

resource "azapi_resource" "dts_task_hub" {
  type      = "Microsoft.DurableTask/schedulers/taskHubs@2025-04-01-preview"
  name      = "idp-agents"
  parent_id = azapi_resource.dts.id

  body = {
    properties = {}
  }
}
