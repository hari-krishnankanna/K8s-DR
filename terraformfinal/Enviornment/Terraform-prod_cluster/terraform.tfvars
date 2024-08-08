resource_group_name           = "myGroup"
location                      = "centralindia"
vm_name                       = "prod-vm"
networkinterface_name         =  "prod-NI"
pubip_name                    =  "prod-ip"
vnet_name                     = "myVNet"
address_space                 = ["10.2.0.0/16"]
aks_subnet_name               = "aks-subnet"
aks_subnet_prefix             = "10.2.1.0/24"
storage_subnet_prefix         = "10.2.3.0/24"
storage_subnet_name           = "storage-subnet"
aks_name                      = "myAKSCluster"
dns_prefix                    = "myaks"
acr_virtual_network_link_name = "mylink"
private_dns_a_record_acr_name = "myacrdnsrecord"
private_dns_zone_groupacr_name = "myacrdnsgroup"
private_endpoint_prod_acr_name = "myacrendpointprod"
prodacr_service_connection_name = "myacrserviceconnprod"
acrprod_name                  = "myacrprodnewtesting"
private_endpoint_files_name  = "fileshare_pvt_endpoint"
service_connection_file_name  = "fileshare_service_conn"
zone_group_files_name        = "fileshare_zone_grp"
virtuallink_files_name       = "fileshare_virtuallink"
fileshare_name               = "ftestprodbackup"
storagefile_name             = "fstoragebackup"
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
