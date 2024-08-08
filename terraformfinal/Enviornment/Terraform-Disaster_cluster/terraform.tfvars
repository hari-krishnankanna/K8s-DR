resource_group_name           = "mydrGroup"
acr_resource_group_name       = "myGroup"
location                      = "westus"
vnet_name                     = "DR-myVNet"
vm_name                       = "DR-vm"
networkinterface_name         = "DR-NI"
pubip_name                    = "DR-ip"
address_space                 = ["10.3.0.0/16"]
acr_name                      = "myacrprodnewtesting"
aks_subnet_name               = "aks-DR-subnet"
aks_subnet_prefix             = "10.3.1.0/24"
aks_name                      = "myDRCluster"
dns_prefix                    = "myaks"
node_count                    = 1
vm_size                       = "Standard_DS2_v2"
dracr_service_connection_dr_name = "dr_service_conn"
acr_virtual_network_link_dr_name = "dr_virtual_network_link"
private_endpoint_prod_acr_dr_name = "dr-pvt-endpoint"
private_dns_zone_groupacr_dr_name = "dr-dns-zonegrp"
private_dns_a_record_acr_dr_name = "dr-dns-zone"
private_endpoint_storage_dr_name = "dr-storage-pvt.endpoint"
dr_storage_service_conn_name  = "dr_storage_service_conn"
storage_dns_zonegrp_name    = "dr-storage_dns_zonegrp"
storage_virtual_link_name = "dr-storage_virtual_link"
storage_dns_record_name = "dr-storage_dns_record"
virtuallink_files_DR_name = "dr-files_virtuallink"
private_endpoint_files_DR_name = "dr-files-pvt-endpoint"
service_connection_file_DR_name = "dr-files-service-conn"
zone_group_files_DR_name = "dr-files-zonegrp"
private_dnsfiles_DR_name = "dr-files-dns-zone"
storagefile_name = "fstoragebackup" 
fileshare_name = "ftestprodbackup"
acr_subnet_prefix  = "10.3.2.0/24"
acr_subnet_name    =  "acr-subnet"
storage_name  = "productionanddrvelero"
storage_subnet_name   = "DR-storage_subnet"
storage_subnet_prefix = "10.3.3.0/24"
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
