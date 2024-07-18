resource_group_name           = "mydrGroup"
acr_resource_group_name       = "myGroup"
location                      = "westus"
vnet_name                     = "DR-myVNet"
address_space                 = ["10.3.0.0/16"]
acr_name                      = "exampleacrharitest"
aks_subnet_name               = "aks-DR-subnet"
aks_subnet_prefix             = "10.3.1.0/24"
aks_name                      = "myDRCluster"
dns_prefix                    = "myaks"
node_count                    = 3
vm_size                       = "Standard_DS2_v2"
#acr_subnet_prefix  = "10.2.2.0/24"
#acr_subnet_name    =  "acr-subnet"
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

