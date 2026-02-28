resource "azurerm_monitor_metric_alert" "ai_token_usage" {
  name                = "idp-core-${var.environment} - AI Token Usage High"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [azurerm_cognitive_account.openai.id]
  description         = "Alert when AI token usage is high"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT1H"

  criteria {
    metric_namespace = "Microsoft.CognitiveServices/accounts"
    metric_name      = "TokenTransaction"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 50000
  }

  action {
    action_group_id = var.environment == "prd" ? local.monitor_action_groups.critical.id : local.monitor_action_groups.informational.id
  }
}

resource "azurerm_monitor_metric_alert" "app_insights_error_rate" {
  name                = "idp-core-${var.environment} - Error Rate High"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [azurerm_application_insights.ai.id]
  description         = "Alert when error rate is high"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "requests/failed"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 10
  }

  action {
    action_group_id = var.environment == "prd" ? local.monitor_action_groups.critical.id : local.monitor_action_groups.informational.id
  }
}
