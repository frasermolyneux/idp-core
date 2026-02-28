# IDP Core Infrastructure

## Overview
Terraform-only infrastructure repository for the Internal Developer Platform. Deploys shared Azure resources consumed by `idp-web` and `idp-agents`.

## Build & Deploy
- `cd terraform && terraform init -backend-config=backends/dev.backend.hcl && terraform plan -var-file=tfvars/dev.tfvars`
- CI/CD: GitHub Actions with OIDC authentication to Azure

## Project Structure
- `terraform/` — Root Terraform module
  - `providers.tf` — Provider config and backend
  - `variables.tf` — Input variables
  - `ai-foundry.tf` — AI Hub, Project, model deployments (GPT-5-mini, GPT-5.1, text-3-small embeddings)
  - `ai-search.tf` — Azure AI Search (free tier) for RAG
  - `app-insights.tf` — Application Insights with 25% sampling
  - `app-registration.tf` — Entra app registration for user sign-in + app roles (Admin, User)
  - `cosmos-db.tf` — Cosmos DB (free tier): conversations, messages, campaigns containers
  - `redis.tf` — Azure Cache for Redis (Basic C0) for reliable streaming
  - `key-vault.tf` — Key Vault for secrets (GitHub App PEM, client secrets)
  - `managed-identities.tf` — User-assigned MIs for idp-web and idp-agents
  - `role-assignments.tf` — MI permissions (Key Vault, AI Foundry, subscriptions)
  - `alerts.tf` — Token usage and error rate alerts
  - `durable-task-scheduler.tf` — DTS + Task Hub (Consumption SKU)
  - `github-app.tf` — Key Vault secret for GitHub App private key
  - `backends/` — Backend configs per environment
  - `tfvars/` — Variable files per environment

## Conventions
- Azure provider ~>4.61.0 with azurerm backend
- Resource naming: `{resource-type}-idp-core-{env}-{location}`
- All resources in `swedencentral`
- Remote state referenced by idp-web and idp-agents via `requires_terraform_state_access`
- Follows org patterns from platform-connectivity, platform-monitoring
