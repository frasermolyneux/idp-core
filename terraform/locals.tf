locals {
  workload_resource_groups = {
    for location in [var.location] :
    location => data.terraform_remote_state.platform_workloads.outputs.workload_resource_groups[var.workload_name][var.environment].resource_groups[lower(location)]
  }

  workload_resource_group = local.workload_resource_groups[var.location]

  resource_prefix = "${var.workload_name}-${var.environment}-${var.location}"
  location_short  = substr(var.location, 0, 3)

  platform_monitoring_workspace_id = data.terraform_remote_state.platform_monitoring.outputs.log_analytics.id
  monitor_action_groups            = data.terraform_remote_state.platform_monitoring.outputs.monitor_action_groups

  app_insights_name = "ai-${var.workload_name}-${var.environment}-${var.location}"

  app_insights_sampling_percentage = {
    dev = 25
    prd = 75
  }
}
