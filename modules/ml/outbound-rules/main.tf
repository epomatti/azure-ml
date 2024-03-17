terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "1.12.1"
    }
  }
}

# TODO: Adding only this resource did not complete the setup.
resource "azapi_resource" "data_lake" {
  type      = "Microsoft.MachineLearningServices/workspaces/outboundRules@2023-10-01"
  name      = "datalake"
  parent_id = var.aml_workspace_id
  body = jsonencode({
    properties = {
      type = "PrivateEndpoint"
      destination = {
        serviceResourceId = "${var.data_lake_id}"
        sparkEnabled      = true
        subresourceTarget = "dfs"
      }
    }
  })
}
