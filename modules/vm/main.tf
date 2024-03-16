resource "azurerm_public_ip" "windows11" {
  name                = "pip-windows11"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "windows11" {
  name                = "nic-windows11"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "windows11"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows11.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_windows_virtual_machine" "windows11" {
  name                  = "vm-windows11"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.size
  admin_username        = "winuser"
  admin_password        = "P@ssw0rd.123"
  network_interface_ids = [azurerm_network_interface.windows11.id]

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    name                 = "osdisk-windows11"
    caching              = "ReadOnly"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-23h2-pron"
    version   = "latest"
  }
}
