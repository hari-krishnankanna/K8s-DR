resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
 # kubernetes_version  = "1.30.2"

  default_node_pool {
    name       = "default"
  # orchestrator_version = "1.30.2"
    node_count = var.node_count
    vm_size    = var.vm_size
    vnet_subnet_id = var.aks_subnet_id
  }
  private_cluster_enabled = true
  identity {
    type = "SystemAssigned"
  }

# auto_upgrade_profile {
 #   upgrade_channel = "none"
 # }

 network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    network_policy    = "azure"
  }
  }
resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}