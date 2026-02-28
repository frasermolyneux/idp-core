# Random UUIDs for OAuth2 scope and app role IDs
resource "random_uuid" "mcp_read_scope_id" {
  keepers = { environment = var.environment }
}

resource "random_uuid" "mcp_readwrite_scope_id" {
  keepers = { environment = var.environment }
}

resource "random_uuid" "idp_admin_role_id" {
  keepers = { environment = var.environment }
}

resource "random_uuid" "idp_operator_role_id" {
  keepers = { environment = var.environment }
}

resource "random_uuid" "idp_user_role_id" {
  keepers = { environment = var.environment }
}

# IDP Agents App Registration (API)
resource "azuread_application" "idp_agents" {
  display_name     = "idp-agents-${var.environment}"
  description      = "IDP Agents API"
  sign_in_audience = "AzureADMyOrg"

  identifier_uris = ["api://idp-agents-${var.environment}"]

  api {
    known_client_applications = ["aebc6443-996d-45c2-90f0-388ff96faa56"]

    oauth2_permission_scope {
      admin_consent_description  = "Read MCP resources"
      admin_consent_display_name = "Mcp.Read"
      id                         = random_uuid.mcp_read_scope_id.result
      type                       = "User"
      user_consent_description   = "Read MCP resources"
      user_consent_display_name  = "Mcp.Read"
      value                      = "Mcp.Read"
      enabled                    = true
    }

    oauth2_permission_scope {
      admin_consent_description  = "Read and write MCP resources"
      admin_consent_display_name = "Mcp.ReadWrite"
      id                         = random_uuid.mcp_readwrite_scope_id.result
      type                       = "User"
      user_consent_description   = "Read and write MCP resources"
      user_consent_display_name  = "Mcp.ReadWrite"
      value                      = "Mcp.ReadWrite"
      enabled                    = true
    }
  }

  app_role {
    allowed_member_types = ["User", "Application"]
    description          = "IDP Administrator"
    display_name         = "IDP.Admin"
    id                   = random_uuid.idp_admin_role_id.result
    value                = "IDP.Admin"
    enabled              = true
  }

  app_role {
    allowed_member_types = ["User", "Application"]
    description          = "IDP Operator"
    display_name         = "IDP.Operator"
    id                   = random_uuid.idp_operator_role_id.result
    value                = "IDP.Operator"
    enabled              = true
  }

  app_role {
    allowed_member_types = ["User", "Application"]
    description          = "IDP User"
    display_name         = "IDP.User"
    id                   = random_uuid.idp_user_role_id.result
    value                = "IDP.User"
    enabled              = true
  }

  web {
    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }

  prevent_duplicate_names = true
}

resource "azuread_service_principal" "idp_agents" {
  client_id                    = azuread_application.idp_agents.client_id
  app_role_assignment_required = false

  owners = [
    data.azuread_client_config.current.object_id
  ]
}

# Internal Developer Platform App Registration (Web App sign-in)
resource "azuread_application" "idp" {
  display_name     = "internal-developer-platform-${var.environment}"
  description      = "Internal Developer Platform Web Application"
  sign_in_audience = "AzureADMyOrg"

  web {
    redirect_uris = [
      "https://localhost:5001/signin-oidc"
    ]

    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }

  required_resource_access {
    resource_app_id = azuread_application.idp_agents.client_id

    resource_access {
      id   = random_uuid.mcp_read_scope_id.result
      type = "Scope"
    }

    resource_access {
      id   = random_uuid.mcp_readwrite_scope_id.result
      type = "Scope"
    }
  }

  prevent_duplicate_names = true
}

resource "azuread_service_principal" "idp" {
  client_id                    = azuread_application.idp.client_id
  app_role_assignment_required = false

  owners = [
    data.azuread_client_config.current.object_id
  ]
}

resource "azuread_application_password" "idp" {
  application_id = azuread_application.idp.id

  rotate_when_changed = {
    rotation = time_rotating.thirty_days.id
  }
}

# Pre-authorize the web app for OBO on idp-agents
resource "azuread_application_pre_authorized" "idp_web_obo" {
  application_id       = azuread_application.idp_agents.id
  authorized_client_id = azuread_application.idp.client_id
  permission_ids = [
    random_uuid.mcp_read_scope_id.result,
    random_uuid.mcp_readwrite_scope_id.result,
  ]
}

# Store the OBO client secret in Key Vault
resource "azurerm_key_vault_secret" "idp_client_id" {
  name         = "idp-web-${var.environment}-clientid"
  value        = azuread_application.idp.client_id
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.deploy_kv_secrets_officer]
}

resource "azurerm_key_vault_secret" "idp_client_secret" {
  name         = "idp-web-${var.environment}-clientsecret"
  value        = azuread_application_password.idp.value
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.deploy_kv_secrets_officer]
}
