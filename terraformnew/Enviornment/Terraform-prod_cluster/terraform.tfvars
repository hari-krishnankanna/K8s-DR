resource_group_name           = "myGroup"
location                      = "eastus"
vm_name                       = "prod-vm"
networkinterface_name         =  "prod-NI"
pubip_name                    =  "prod-ip"
vnet_name                     = "myVNet"
address_space                 = ["10.2.0.0/16"]
private_endpoint_name         = "mytest"
virtuallink_name              = "myventlink"
storagefile_name              = "mystorageaccount"
fileshare_name                = " mytestfileshare"
aks_subnet_name               = "aks-subnet"
aks_subnet_prefix             = "10.2.1.0/24"
storage_subnet_prefix         = "10.2.3.0/24"
storage_subnet_name           = "storage-subnet"
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
