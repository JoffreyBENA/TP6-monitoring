#!/bin/bash

echo -e "\033[1;32;4m-- Etape 1/8: Définition et Configuration du projet GCP --\033[0m"

# Définition du projet GCP
export GCP_PROJECT="exalted-airfoil-402614"  # Remplacez par le nom de votre projet

# Configuration du projet GCP
echo "Configuration du projet GCP : $GCP_PROJECT"
gcloud config set project $GCP_PROJECT

# Vérification de la configuration
echo "Vérification de la configuration du projet GCP :"
gcloud config list

# Message de confirmation
echo "Le projet GCP a été configuré avec succès : $GCP_PROJECT"

gcloud services enable compute.googleapis.com --project=$GCP_PROJECT
gcloud services enable cloudresourcemanager.googleapis.com --project=$GCP_PROJECT
gcloud services enable iam.googleapis.com --project=$GCP_PROJECT
gcloud services enable monitoring.googleapis.com --project=$GCP_PROJECT
gcloud services enable logging.googleapis.com --project=$GCP_PROJECT
gcloud services enable container.googleapis.com --project=$GCP_PROJECT
gcloud services enable dns.googleapis.com --project=$GCP_PROJECT
gcloud services enable run.googleapis.com --project=$GCP_PROJECT
gcloud services enable sourcerepo.googleapis.com --project=$GCP_PROJECT

# --------------------------------------------------------------------

echo -e "\033[1;32;4m-- Etape 2/8: Vérification de la présence de la clé ssh et Génération si nécessaire --\033[0m"

# Chemin du dossier .ssh
ssh_dir="$HOME/.ssh"

# Vérifier si le dossier .ssh existe
if [ ! -d "$ssh_dir" ]; then
    # Si le dossier n'existe pas, le créer
    mkdir "$ssh_dir"
fi

# Vérifier si une clé SSH existe déjà
if [ ! -f "$ssh_dir/id_rsa" ]; then
    # Si la clé n'existe pas, générer une nouvelle clé SSH
    ssh-keygen -t rsa -b 4096
else
    echo "Une clé SSH existe déjà dans le dossier $ssh_dir."
fi

# --------------------------------------------------------------------

echo -e "\033[1;32;4m-- Etape 3/8: Vérification de Terrafrom et Installation si nécessaire --\033[0m"

# Installation de Terraform s'il n'est pas installé
if ! command -v terraform &> /dev/null; then
    echo "Terraform n'est pas installé. Installation en cours..."
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
    sudo apt update
    sudo apt install terraform
    if [ $? -eq 0 ]; then
        echo -e "\033[33mTerraform a été installé avec succès.\033[0m"
    else
        echo -e "\033[31mL'installation de Terraform a échoué.\033[0m"
        exit 1
    fi
else
    echo -e "\033[31mTerraform est déjà installé.\033[0m"
fi

# Vérification de la présence des fichiers Terraform
if [ ! -d "terraform" ] || [ ! -f "terraform/variables.tf" ] || [ ! -f "terraform/main.tf" ] || [ ! -f "terraform/vpc/variables.tf" ] || [ ! -f "terraform/vpc/main.tf" ] || [ ! -f "terraform/gke-cluster/variables.tf" ] || [ ! -f "terraform/gke-cluster/main.tf" ] || [ ! -f "terraform/service_account/variables.tf" ] || [ ! -f "terraform/service_account/main.tf" ] || [ ! -f "terraform/firewall/variables.tf" ] || [ ! -f "terraform/firewall/main.tf" ]; then
    echo -e "\033[33mCertains fichiers Terraform sont manquants. Clonage du référentiel...\033[0m"
    git clone https://gitlab.com/JoffreyBENA/TP5-logging.git
    cd TP5-logging/deploy-gke-cluster/terraform
else
    cd terraform
fi

# --------------------------------------------------------------------

echo -e "\033[1;32;4m-- Etape 4/8: Initialisation de Terrafrom et Création des machines --\033[0m"

# Initialisation de Terraform si c'est la première exécution
if [ ! -d ".terraform" ]; then
    echo -e "\033[33mInitialisation de Terraform...\033[0m"
    terraform init
fi

# Création des machines avec Terraform
echo -e "\033[33mCréation des machines avec Terraform...\033[0m"
terraform apply -auto-approve
cd ..

# # --------------------------------------------------------------------
# echo -e "\033[1;32;4m-- Etape 4/8: Génération des inventaires dynamiques Ansible  --\033[0m"

# # Génération de l'inventaire dynamique dans le fichiers inventori.ini avec les adresses IP internes des VMs déployées par Terraform :
# echo -e "\033[33mCréation du fichier 'inventory.ini'...\033[0m"
# cd ./ansible
# rm -f inventory.ini
# cd ..
# ./creation-inventory.sh >ansible/inventory.ini

# # # Génération de l'inventaire dynamique dans le fichiers vars.yml avec les adresse IP internes des Vms déployées par Terraform :

# # # Remplacement des adresses IP dans le fichier vars.yml
# cd ./terraform
# GKE_external_ip=$(terraform output cluster_external_endpoint | sed 's/"//g')

# sed -i "" "s/^GKE_external_ip:.*/GKE_external_ip: \"$GKE_external_ip\"/" ../ansible/vars.yml

# cd ..

# echo -e "\033[0;32mLes adresses IP internes ont été mises à jour dans le fichier vars.yml.\033[0m"

# --------------------------------------------------------------------

# echo -e "\033[1;32;4m-- Etape 5/8: Importation de l'image Docker de l'app dans Google Container Registry --\033[0m"

# # Importation de l'image et stockage dans GCR

# # Vérification si le service Docker est en cours d'exécution
# if ! docker info > /dev/null 2>&1; then
#     echo "Le service Docker n'est pas en cours d'exécution. Démarrage de Docker..."
#     # sudo service docker start #Linux
#     # start process "Docker" #PowerShell
#     sudo open -a Docker #Mac
# fi

# # Ajoutez une pause de 10 secondes
# sleep 10

# # Define your project name and region
# GCP_REGION="eu-west9"  # Remplacez par la région de votre projet GCP

# # Define your image name and tag
# IMAGE_NAME="joffreyb/imagepythontp3-gitlabci"
# IMAGE_TAG="v1.0"  # Remplacez par le tag de votre choix

# # Define CONTAINER Registry image URL
# CONTAINER_REGISTRY_IMAGE="gcr.io/$GCP_PROJECT/$IMAGE_NAME:$IMAGE_TAG"

# # Pull the image from Docker Hub
# docker pull $IMAGE_NAME:$IMAGE_TAG || {
#     echo "Échec lors du pull de l'image depuis Docker Hub."
#     exit 1
# }

# # Configure Docker to authenticate with CONTAINER Registry
# gcloud auth configure-docker "gcr.io" || {
#     echo "Échec lors de la configuration de Docker pour CONTAINER Registry."
#     exit 1
# }

# # Tag and push the image to CONTAINER Registry
# docker tag $IMAGE_NAME:$IMAGE_TAG $CONTAINER_REGISTRY_IMAGE && docker push $CONTAINER_REGISTRY_IMAGE || {
#     echo "Échec lors du tag et du push de l'image vers CONTAINER Registry."
#     exit 1
# }

# echo "Terminé ! L'image Docker est importée dans CONTAINER Registry dans la région $GCP_REGION."

# --------------------------------------------------------------------

echo -e "\033[1;32;4m-- Etape 7/8: Déploiement sur le cluster GKE --\033[0m"

cd ./terraform
REGION=$(terraform output region  | sed 's/"//g')
CLUSTER_NAME=$(terraform output cluster_name  | sed 's/"//g')
cd ..

gcloud config set project $GCP_PROJECT
# gcloud config set project exalted-airfoil-402614 
gcloud container clusters get-credentials $CLUSTER_NAME --zone=$REGION --project=$GCP_PROJECT
# gcloud container clusters get-credentials my-gke-cluster --zone=europe-west9 --project=exalted-airfoil-402614                                                                     

# --------------------------------------------------------------------

# # Installation des configurations cluster (securité)
# kubectl create -f https://download.elastic.co/downloads/eck/2.9.0/crds.yaml

# # Installation de l'opérateur ECK
# kubectl apply -f https://download.elastic.co/downloads/eck/2.9.0/operator.yaml

# # Déploiement de la plateforme ECK
# kubectl apply -f https://raw.githubusercontent.com/elastic/cloud-on-k8s/2.9/config/recipes/elastic-agent/fleet-kubernetes-integration.yaml

# Déploiement de l'application Nginx
kubectl apply -f ../kubernetes/nginx/nginx-deployment.yml
kubectl apply -f ../kubernetes/nginx/nginx-service.yml

# Déploiement de l'application App (Python-handle-it)
kubectl apply -f ../kubernetes/app/app-deployment.yml
kubectl apply -f ../kubernetes/app/app-service.yml

# # Helm :
# helm version
# helm repo add elastic https://helm.elastic.co
# helm repo update
# helm install elasticsearch elastic/elasticsearch -f ./values.yaml
# kubectl port-forward svc/elasticsearch-master 9200 &
# kubectl port-forward deployment/kibana-kibana 5601
# # helm install elasticsearch elastic/elasticsearch
# # helm install logstash elastic/logstash
# # helm install filebeat elastic/filebeat
# helm install kibana elastic/kibana
# # kubectl get pods

# # --------------------------------------------------------------------

# Ajoutez une pause de 60 secondes
sleep 60

# #--------------------------------------------------------------------

kubectl get deployments
kubectl get pods
kubectl get services

# kubectl config unset current-context

#--------------------------------------------------------------------

# Ajoutez une pause de 60 secondes
sleep 60

#--------------------------------------------------------------------

# Récupérer les ressources Kubernetes avec l'étiquette "elastic"
kubectl get elastic

#--------------------------------------------------------------------

# Ajoutez une pause de 60 secondes
sleep 60

#--------------------------------------------------------------------

# Récupérer le mot de passe de l'utilisateur "elastic" depuis le secret
echo -e "Le mot de passe de l'utilisateur 'elastic' est : \033[1;31;4m$(kubectl get secret elasticsearch-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)\033[0m"

echo "Installation et configuration terminées."

# --------------------------------------------------------------------

# Ajoutez une pause de 1min
sleep 60

# --------------------------------------------------------------------
# Mettre en place un port-forwarding pour accéder à Kibana localement
kubectl port-forward service/kibana-kb-http 5601

# Ctrl + C : pour quitter le port-fowarding

# --------------------------------------------------------------------
# # Installation d'Elasticsearch
# kubectl apply -f ../kubernetes/elasticsearch/elasticsearch-deployment.yaml
# kubectl apply -f ../kubernetes/elasticsearch/elasticsearch-service.yaml

# # Installation de Logstash
# kubectl apply -f ../kubernetes/logstash/logstash-configmap.yaml
# kubectl apply -f ../kubernetes/logstash/logstash-deployment.yaml
# kubectl apply -f ../kubernetes/logstash/logstash-service.yaml

# # Installation de Filebeat
# kubectl apply -f ../kubernetes/filebeat/filebeat-config.yaml
# kubectl apply -f ../kubernetes/filebeat/filebeat-deployment.yaml

# # Installation de Kibana
# kubectl apply -f ../kubernetes/kibana/kibana-deployment.yaml
# kubectl apply -f ../kubernetes/kibana/kibana-service.yaml

# # Déploiement de l'application Nginx
# kubectl apply -f ../kubernetes/nginx/nginx-deployment.yml
# kubectl apply -f ../kubernetes/nginx/nginx-service.yml

# echo "Installation et configuration terminées."

# # --------------------------------------------------------------------

# # Ajoutez une pause de 10 secondes
# sleep 15

# #--------------------------------------------------------------------

# kubectl get deployments
# kubectl get pods
# kubectl get services

# # kubectl config unset current-context

# #--------------------------------------------------------------------
# # Création d'un modèle d'index Elasticsearch pour les logs Nginx (personnalisé selon vos besoins)

# # Configuration de Filebeat pour récupérer les logs de Nginx
# # Assurez-vous que les logs Nginx sont stockés dans le bon répertoire sur les nœuds Kubernetes.

# # Configuration de Filebeat pour récupérer les logs des conteneurs
# # Assurez-vous que les logs des conteneurs sont accessibles et configurés dans la configuration Filebeat.

# # Définition de la stratégie de stockage et de rotation des logs pour garder les logs pendant 2 jours (à configurer dans Elasticsearch et Logstash).

# # Ajoutez d'autres étapes spécifiques à votre configuration, telles que la configuration de l'index pattern dans Kibana.