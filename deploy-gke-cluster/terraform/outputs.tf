output "instance-user" {
    value = var.user
}

# Output pour l'endpoint externe (public) du cluster
output "cluster_external_endpoint" {
    value = module.gke-cluster.cluster_external_endpoint
}

# # Output pour les adresses IP des nœuds du cluster
# output "node_ips" {
#     value = module.gke-cluster.node_ips
# }

# # Output pour l'endpoint interne (privé) du cluster
# output "cluster_internal_endpoint" {
#     value = module.gke-cluster.cluster_internal_endpoint
# }

# output "cluster_ca_certificate" {
#     value = module.gke-cluster.cluster_ca_certificate
#     description = "Certificat CA du cluster GKE"
# }

output "region" {
    value = module.gke-cluster.region
}

output "cluster_name" {
    value = module.gke-cluster.cluster_name
}