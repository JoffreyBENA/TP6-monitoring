
# PROVIDER
provider "google" {
    credentials = file("../credentials.json")
    project     = var.project_id
    region      = var.region
    zone        = var.zone
    scopes      = [ "https://www.googleapis.com/auth/cloud-platform" ]
}

# provider "kubernetes" {
#     host = module.gke-cluster.endpoint
#     cluster_ca_certificate = base64decode(module.gke-cluster.ca_certificate)
#     token = module.gke-cluster.token
# }

# MODULES
module "vpc" {
    source      = "./vpc"
    subnet_cidr = var.subnet_cidr
}

module "service_account" {
    source          = "./service_account"
    project_id      = var.project_id
    region          = var.region
    zone            = var.zone
    key_filename    = var.key_filename
    account_id      = var.account_id
    display_name    = var.display_name
}

module "firewall" {
    depends_on          = [ module.vpc ]
    source              = "./firewall"
    network_self_link   = module.vpc.network_self_link
    subnet_self_link    = module.vpc.subnet_self_link
    firewall_source     = var.firewall_source
}

# VM
module "gke-cluster" {
    depends_on              = [ module.vpc ]
    source                  = "./gke-cluster"
    project_id              = var.project_id
    network_self_link       = module.vpc.network_self_link
    subnet_self_link        = module.vpc.subnet_self_link
    service_account_email   = module.service_account.service_account_email
}

# module "k8s" {
#     depends_on = [ module.gke-cluster ]
#     source = ".k8s_ressources"
    
#     /* ---------- variables peuvent etre egalement surchargées -------*/

#     host     = "${module.gke_cluster.host}"
#     username = "${var.username}"
#     password = "${var.password}"

#         client_certificate     = "${module.gke_cluster.client_certificate}"
#         client_key             = "${module.gke_cluster.client_key}"
#         cluster_ca_certificate = "${module.gke_cluster.cluster_ca_certificate}"
# }

# CLE SSH
resource "google_compute_project_metadata_item" "ssh_keys" {
    key   = "ssh-keys"
    value = "${var.user}:${file("~/.ssh/id_rsa.pub")}"
}
