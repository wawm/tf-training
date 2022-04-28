provider "azurerm" {
  features {}
  subscription_id = "bd6f57c7-b7d0-48f5-ae50-099a8214cfa0"
  client_id       = "455f36ef-0214-43b8-9006-204303dc565b"
  client_secret   = "EtthkXhdJL-z1g~ZW5reCwbbpQDHaOBgy~"
  tenant_id       = "c6233c63-d924-454b-9b2b-3bdfefedf0af"
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.97.0,<=3.3.0" #azurerm versions
    }
  }
  required_version = ">=1.1.0" #terraform version
}
resource "azurerm_resource_group" "azlan-rg" {
  name     = "rg-west"
  location = "westus"
}
resource "azurerm_virtual_network" "azlan-vnet" {
  name                = "azlan-vnet"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.azlan-rg.name
  location            = azurerm_resource_group.azlan-rg.location
}
resource "azurerm_subnet" "azlan-subnet1" {
  name                 = "azlan-subnet1"
  address_prefixes     = ["10.0.1.0/27"]
  virtual_network_name = azurerm_virtual_network.azlan-vnet.name
  resource_group_name  = azurerm_resource_group.azlan-rg.name

}
resource "azurerm_public_ip" "azlan-pubip" {
  name                = "azlan-pubip"
  allocation_method   = "Static"
  resource_group_name = azurerm_resource_group.azlan-rg.name
  location            = azurerm_resource_group.azlan-rg.location
}
resource "azurerm_network_interface" "azlan-nic" {
  name                = "azlan-nic"
  resource_group_name = azurerm_resource_group.azlan-rg.name
  location            = azurerm_resource_group.azlan-rg.location
  ip_configuration {
    name                          = "azlan-int-ip"
    subnet_id                     = azurerm_subnet.azlan-subnet1.id
    public_ip_address_id          = azurerm_public_ip.azlan-pubip.id
    private_ip_address_allocation = "Dynamic"
  }
}
/*
resource "azurerm_windows_virtual_machine" "azlan-winvm" {
  name                  = "azlan-winvm"
  resource_group_name   = azurerm_resource_group.azlan-rg.name
  location              = azurerm_resource_group.azlan-rg.location
  admin_username        = "wawmuser"
  admin_password        = "7KV/bB5Z'N?Y`M`G"
  size                  = "Standard_D4ds_v4"
  network_interface_ids = [azurerm_network_interface.azlan-nic.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  provisioner "local-exec" {
    on_failure = continue
    command = "echo ${azurerm_windows_virtual_machine.azlan-winvm.name} >> vmdetails.txt"
    
  }
    provisioner "local-exec" {
    on_failure = continue
    command = "echo ${azurerm_public_ip.azlan-pubip.ip_address} >> vmdetails.txt"
    
  } */

resource "azurerm_linux_virtual_machine" "azlan-lxvm" {
  name                            = "azlan-lxvm"
  resource_group_name             = azurerm_resource_group.azlan-rg.name
  location                        = azurerm_resource_group.azlan-rg.location
  size                            = "Standard_F2"
  admin_username                  = "azlanuser"
  admin_password                  = "7KV/bB5Z'N?Y`M`G"
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.azlan-nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  provisioner "remote-exec" {
    on_failure = continue
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install nginx -y",
      "sudo systemctl start nginx"
    ]
  }
  connection {
    type     = "ssh"
    user     = azurerm_linux_virtual_machine.azlan-lxvm.admin_username
    password = azurerm_linux_virtual_machine.azlan-lxvm.admin_password
    host     = azurerm_public_ip.azlan-pubip.ip_address
  }
  tags = {
    environment = "staging"
  }
}
output "publicip" {
  value = azurerm_public_ip.azlan-pubip.ip_address
}
