resource "google_container_cluster" "gke-cluster" {
    name     = var.cluster_name
    location = var.region
    project  = var.project_id
    initial_node_count = var.node_count    
    # tags = ["gke-cluster"]

    # Network Configuration
    network       = var.network_self_link
    subnetwork    = var.subnet_self_link
    
    # Cluster properties
    node_config {
        preemptible = true
        tags = [ "nodes" ]
        machine_type = var.machine_type
        disk_size_gb = var.disk_size_gb
        oauth_scopes = [
            "https://www.googleapis.com/auth/compute",
            "https://www.googleapis.com/auth/devstorage.read_only",
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring"
        ]
        # metadata = {
        #     ssh_keys = "${var.user}:${file("~/.ssh/id_rsa.pub")}"
        # }
    }
    # master_auth {
    #     client_certificate_config {
    #     issue_client_certificate = false
    #     }
    # }
}
