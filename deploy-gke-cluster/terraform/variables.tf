variable "project_id" {
    type        = string
    description = "ID du projet GCP"
    default     = "exalted-airfoil-402614"
}

variable "region" {
    type        = string
    description = "Région GCP"
    default     = "europe-west9"
}

variable "zone" {
    type        = string
    description = "Zone GCP"
    default     = "europe-west9-a"
}

variable "user" {
    default     = "joffreym2igcp"
    description = "Nom de l'utilisateur"
    type        = string
}

variable "subnet_cidr" {
    type        = string
    description = "CIDR de la sous-réseau"
    default     = "10.0.0.0/24"
}

variable "firewall_source" {
    description = "IP source pour le firewall"
    default     = ["0.0.0.0/0"]
}

variable "account_id" {
    description = "ID du compte de service."
    default     = "exalted-airfoil-402614"
}

variable "display_name" {
    description = "Nom du compte de service."
    default     = "Compute Engine default service account"
}

variable "key_filename" {
    description = "Comment déployer la clé et comment la nommer."
    default     = "./credentials.json"
}

variable "cluster_name" {
    description = "Nom du cluster GKE"
    default     = "my-gke-cluster"
}