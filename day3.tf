/*
provider "azurerm" {
  features {}
  alias           = "prod-subscription"
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

#local block
locals {
  rgname   = "rg-wanazlan"
  location = "centralus"
  rgname4  = "rg-wanazlan007"
}
#List condition
resource "azurerm_resource_group" "azlan-rg" {
  provider = azurerm.prod-subscription
  count    = 6
  name     = "rg-wawm-${count.index}"
  location = "westus"
}
resource "azurerm_resource_group" "azlan-rg1" {
  provider = azurerm.prod-subscription
  count    = length(var.rg-list)
  name     = var.rg-list[count.index]
  location = "westus"

}
#map condition
resource "azurerm_resource_group" "azlan-rg2" {
  provider = azurerm.prod-subscription
  for_each = var.rg-list1
  name     = each.key
  location = each.value
}
#Local resources
resource "azurerm_resource_group" "azlan-rg3" {
  provider = azurerm.prod-subscription
  name     = local.rgname
  location = local.location
}

resource "azurerm_resource_group" "azlan-rg4" {
  provider = azurerm.prod-subscription
  name     = local.rgname4
  location = local.rgname4 == "rg-wanazlan007" ? "westus" : "eastus" #expression ? True : False
}

#listing output for list objects
output "rgnamelist" {
  value = azurerm_resource_group.azlan-rg1[*].name #splat expression
}
output "rgnamelist1" {
  value = azurerm_resource_group.azlan-rg[*].name #splat expression
}
output "rgnamelist2" {
  value = azurerm_resource_group.azlan-rg3.name
}

output "zip" {
    value = zipmap(azurerm_resource_group.azlan-rg1[*].name,azurerm_resource_group.azlan-rg1[*].location)
}

#Dynamic Block

resource "azurerm_resource_group" "rgname" {
  provider = azurerm.prod-subscription
  name     = "rgname"
  location = "westus"

}
resource "azurerm_network_security_group" "example" {
  provider            = azurerm.prod-subscription
  name                = var.nsgname
  resource_group_name = azurerm_resource_group.rgname.name
  location            = azurerm_resource_group.rgname.location
  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value["name"]
      priority                   = security_rule.value["priority"]
      direction                  = security_rule.value["direction"]
      access                     = security_rule.value["access"]
      protocol                   = security_rule.value["protocol"]
      source_port_range          = security_rule.value["source_port_range"]
      destination_port_range     = security_rule.value["destination_port_range"]
      source_address_prefix      = security_rule.value["source_address_prefix"]
      destination_address_prefix = security_rule.value["destination_address_prefix"]
    }
  }
}

output "nsg" {
  value = azurerm_network_security_group.example
}
*/
