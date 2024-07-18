resource_group_name           = "myGroup"
location                      = "eastus"

vnet_name                     = "myVNet"
address_space                 = ["10.2.0.0/16"]

aks_subnet_name               = "aks-subnet"
aks_subnet_prefix             = "10.2.1.0/24"

aks_name                      = "myAKSCluster"
dns_prefix                    = "myaks"

node_count                    = 3
vm_size                       = "Standard_DS2_v2"
acr_subnet_prefix  = "10.2.2.0/24"
acr_subnet_name    =  "acr-subnet"
additional_node_pools = [
 {
    name       = "pool1"
    vm_size    = "Standard_DS2_v2"
    node_count = 2
  },
  {
    name       = "pool2"
    vm_size    = "Standard_DS2_v2"
    node_count = 2
  }
]

#api_server_authorized_ip_ranges = ["203.0.113.0/24", "198.51.100.0/24"]

#additional_node_pools:
 #   name       = "pool1"
  #  vm_size    = "Standard_DS2_v2"
   # node_count = 2
