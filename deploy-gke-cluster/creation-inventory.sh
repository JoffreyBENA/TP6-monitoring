# Récupération des adresses IP des VMs depuis les sorties Terraform
cd ./terraform
GKE_public_ip=$(terraform output cluster_external_endpoint  | sed 's/"//g')

GKE_nodes1=$(gcloud compute instances list --format="value(EXTERNAL_IP)" | head -n 1)
GKE_nodes2=$(gcloud compute instances list --format="value(EXTERNAL_IP)" | head -n 2 | tail -n 1)
GKE_nodes3=$(gcloud compute instances list --format="value(EXTERNAL_IP)" | head -n 3 | tail -n 1)

user=$(terraform output instance-user | sed 's/"//g')

# Génération de l'inventaire avec les adresses IP
echo "[gke-cluster]"
echo $GKE_public_ip  ansible_user=$user

echo "[gke-nodes]"
echo $GKE_nodes1  ansible_user=$user
echo $GKE_nodes2  ansible_user=$user
echo $GKE_nodes3  ansible_user=$user