resource "azurerm_machine_learning_compute_instance" "dev1" {
  name                          = "dev1"
  location                      = var.location
  machine_learning_workspace_id = var.machine_learning_workspace_id
  virtual_machine_size          = var.instance_vm_size
  authorization_type            = "personal"
  node_public_ip_enabled        = var.instance_node_public_ip_enabled

  ssh {
    public_key = var.ssh_public_key
  }

  lifecycle {
    ignore_changes = [
      # This will be managed by the Machine Learning service
      subnet_resource_id
    ]
  }
}
