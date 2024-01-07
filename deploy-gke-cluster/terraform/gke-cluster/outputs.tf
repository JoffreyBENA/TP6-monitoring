# # Certificat CA du cluster GKE
# output "cluster_ca_certificate" {
#     value       = google_container_cluster.gke-cluster.master_auth.0.cluster_ca_certificate
#     description = "Certificat CA du cluster GKE"
# }

# Output pour l'endpoint externe (public) du cluster
output "cluster_external_endpoint" {
    value = google_container_cluster.gke-cluster.endpoint
    description = "Endpoint externe (public) du cluster GKE"
}

# Output pour le nom du cluster GKE
output "cluster_name" {
    value       = google_container_cluster.gke-cluster.name
    description = "Nom du cluster GKE"
}

# Outpur pout la région du cluster GKE
output "region" {
    value       = google_container_cluster.gke-cluster.location
    description = "Région du cluster GKE"
}

# # Output pour les adresses IP des nœuds du cluster
# output "node_ips" {
#     value       = google_container_cluster.gke-cluster.node_version
#     description = "Adresses IP des nœuds du cluster GKE"
# }

# # Output pour l'endpoint interne (privé) du cluster
# output "cluster_internal_endpoint" {
#     value = data.google_container_cluster.gke_cluster.internal_ip
# }