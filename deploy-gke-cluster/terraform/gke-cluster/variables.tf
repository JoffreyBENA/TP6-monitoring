variable "cluster_name" {
    type        = string
    description = "Nom du cluster GKE"
    default     = "my-gke-cluster"
}

variable "machine_type" {
    type        = string
    description = "Type de machine du nœud GKE"
    default     = "e2-standard-2"
}

variable "region" {
    type        = string
    description = "Région du cluster GKE"
    default     = "europe-west9"
}

variable "zone" {
    type        = string
    description = "Zone du cluster GKE"
    default     = "europe-west9-c"
}

variable "project_id" {
    type        = string
    description = "ID du projet Google Cloud"
}

variable "user" {
    default     = "joffreym2igcp"
    description = "Nom de l'utilisateur"
    type        = string
}

variable "network_self_link" {
    type        = string
    description = "Lien vers le réseau Google Cloud"
}

variable "subnet_self_link" {
    type        = string
    description = "Lien vers le sous-réseau Google Cloud"
}

variable "service_account_email" {
    description = "Email du compte de service"
}

variable "node_count" {
    type        = number
    description = "Nombre de nœuds du cluster GKE"
    default     = 1
}

variable "disk_size_gb" {
    type        = number
    description = "Taille du disque du nœud GKE"
    default     = 20
}

variable "custom_node_names" {
    type    = list(string)
    default = ["node-1", "node-2", "node-3"]
}