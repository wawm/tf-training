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

resource "azurerm_resource_group" "azlan-rg" {
  provider = azurerm.prod-subscription
  name     = var.rg-name[0]
  location = var.rg-name[1]

}

resource "azurerm_storage_account" "azlan-storageacc" {
  name                     = "wanazlanstorageacc85"
  resource_group_name      = azurerm_resource_group.azlan-rg.name
  location                 = azurerm_resource_group.azlan-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_network_security_group" "azlan-nsg" {
  provider            = azurerm.prod-subscription
  name                = var.azlan-nsg-name
  resource_group_name = azurerm_resource_group.azlan-rg.name
  location            = azurerm_resource_group.azlan-rg.location
    security_rule = [ {
    access = "value"
    description = "value"
    destination_address_prefix = "value"
    destination_address_prefixes = [ "value" ]
    destination_application_security_group_ids = [ "value" ]
    destination_port_range = "value"
    destination_port_ranges = [ "value" ]
    direction = "value"
    name = "value"
    priority = 1
    protocol = "value"
    source_address_prefix = "value"
    source_address_prefixes = [ "value" ]
    source_application_security_group_ids = [ "value" ]
    source_port_range = "value"
    source_port_ranges = [ "value" ]
  } ]
}
resource "azurerm_network_security_rule" "azlan-nsg-rule" {
  provider                    = azurerm.prod-subscription
  name                        = var.azlan-nsg-rule-name
  direction                   = var.azlan-nsg-rule-direction
  access                      = var.azlan-nsg-rule-access
  protocol                    = var.azlan-nsg-rule-protocol
  source_port_range           = var.azlan-nsg-rule-sr-port-range
  destination_port_range      = var.azlan-nsg-rule-dst-port-range
  source_address_prefix       = var.azlan-nsg-rule-sr-addr-prefix
  destination_address_prefix  = var.azlan-nsg-rule-dst-addr-prefix
  priority                    = var.azlan-nsg-rule-pri
  resource_group_name         = azurerm_resource_group.azlan-rg.name
  network_security_group_name = azurerm_network_security_group.azlan-nsg.name
}

resource "azurerm_network_security_rule" "azlan-nsg-rule1" {
  provider                    = azurerm.prod-subscription
  name                        = var.nsg-azlan-rule1[0]
  direction                   = var.nsg-azlan-rule1[1]
  access                      = var.nsg-azlan-rule1[2]
  protocol                    = var.nsg-azlan-rule1[3]
  source_port_range           = var.nsg-azlan-rule1[4]
  destination_port_range      = var.nsg-azlan-rule1[5]
  source_address_prefix       = var.nsg-azlan-rule1[6]
  destination_address_prefix  = var.nsg-azlan-rule1[7]
  priority                    = var.nsg-azlan-rule1[8]
  resource_group_name         = azurerm_resource_group.azlan-rg.name
  network_security_group_name = azurerm_network_security_group.azlan-nsg.name
}

resource "azurerm_network_security_rule" "azlan-nsg-rule2" {
  provider                    = azurerm.prod-subscription
  name                        = var.azlan-nsg-rule2.name
  direction                   = var.azlan-nsg-rule2.direction
  access                      = var.azlan-nsg-rule2.access
  protocol                    = var.azlan-nsg-rule2.protocol
  source_port_range           = var.azlan-nsg-rule2.source_port_range
  destination_port_range      = var.azlan-nsg-rule2.destination_port_range
  source_address_prefix       = var.azlan-nsg-rule2.source_address_prefix
  destination_address_prefix  = var.azlan-nsg-rule2.destination_address_prefix
  priority                    = var.azlan-nsg-rule2.priority
  resource_group_name         = azurerm_resource_group.azlan-rg.name
  network_security_group_name = azurerm_network_security_group.azlan-nsg.name
}
output "nsg-rule" {
  value = azurerm_network_security_rule.azlan-nsg-rule.destination_port_range
}

data "azurerm_resource_group" "rg-datasource" {
  name = "rg-sea"
}

output "rg-datasource-op" {
  value = data.azurerm_resource_group.rg-datasource.id
}


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

resource "azurerm_resource_group" "azlan-rg2" {
  provider = azurerm.prod-subscription
  for_each = var.rg-list1
  name     = each.key
  location = each.value
}

output "rg-name1" {
  value = azurerm_resource_group.azlan-rg
}
output "rg-name2" {
  value = azurerm_resource_group.azlan-rg1
}
output "rg-name3" {
  value = azurerm_resource_group.azlan-rg2
}
*/
