# Deploy-gke-cluster

Documentation du Déploiement Automatisé d'un cluster kubernetes GKE sur Google Cloud Platform (GCP)

## Description des fichiers fournis

``` sh
. # Arborescence du repository
├── README.md
├── ansible
│   ├── ansible.cfg
│   ├── inventory.ini
│   ├── playbook.yml
│   ├── roles
│   │   ├── gke-cluster
│   │       ├── handlers
│   │       │   └── main.yml
│   │       └── tasks
│   │           └── main.yml
│   └── vars.yml
├── creation-inventory.sh
├── credentials.json
├── deploy.sh
├── deployment-schema
│   └── deployment-wordpress-gcp.drawio.png
├── ssh_keys
├── terraform
│   ├── gke-cluster
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── firewall
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── service_account
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── terraform.tfstate
│   ├── terraform.tfstate.backup
│   ├── variables.tf
│   ├── vpc
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── terraform-destroy.sh
├── terraform.tfstate
```

* `README.md` : Le fichier que vous lisez actuellement, qui contient la documentation du projet.
* `ansible` : Le répertoire contenant les fichiers et les rôles Ansible pour le déploiement de votre application.
* `creation-inventory.sh` : Un script pour générer un fichier d'inventaire Ansible à partir de votre infrastructure.
* `credentials.json` : Fichier de configuration contenant des informations d'identification pour se connecter a votre compte GCP
* `deploy.sh` : Un script pour déployer votre application en utilisant Terraform et Ansible.
* `deployment-schema` : Le répertoire contenant des schémas de déploiement.
* ``ssh_keys`` : clés SSH pour l'infrastructure.
* ``terraform`` : Le répertoire contenant les fichiers Terraform pour le déploiement de votre infrastructure.
* ``terraform-destroy.sh`` : Un script pour détruire l'infrastructure créée avec Terraform.

## Description des pré-requis

Pour exécuter ce projet avec succès, vous devez vous assurer de disposer des éléments suivants :

* Un ordinateur avec ``Ansible`` et ``Terraform`` installé.
* Un ``compte GCP`` avec les autorisations appropriées pour créer des machines virtuelles (VM) et des réseaux VPC.
* Une ``clé SSH`` publique nécessaire pour accéder à vos machines virtuelles déployées
* Un fichier ``"credentials.json"`` que vous aurez télécharger depuis la console GCP et stockée a la racine de votre dossier
* La ``configuration de Google Cloud SDK`` : Assurez-vous que vous avez configuré Google Cloud SDK avec vos informations d'identification GCP. Cela vous permettra d'interagir avec votre projet GCP via la ligne de commande.

## Schéma de présentation du déploiement

Voici le schéma permettant de visualiser le flux et l'inter-connection des différents ressources et services :

![Alt text](deployment-schema/deployment-wordpress-gcp.drawio.png)

L'architecture comprend cluster Kubernetes (GKE) pour pouvoir déployer notre application dans le cluster en l'exposant avec un Load Balancer :

* Le cluster kubernetes GKE ``gke-cluster`` est accessible publiquement a travers l'IP public du Load-Balancer et contient l'application déployée.

## Composition et Configuration du dossier Ansible

- ``ansible.cfg`` : Ce fichier contient la configuration globale d'Ansible pour le projet. Il inclus des paramètres tels que les chemins vers les fichiers d'inventaire, les rôles par défaut, et d'autres options de configuration spécifiques à Ansible.

- ``inventory.ini`` : Le fichier "inventory.ini" est notre inventaire Ansible. Il répertorie les serveurs ou les hôtes que nous souhaitons gérer avec Ansible. Les adresses IP et  les noms d'hôte de nos machines virtuelles sont spécifiés dans ce fichier.

- ``playbook.yml`` : Le fichier "playbook.yml" est le playbook Ansible principal pour ce projet. Il contient une liste d'actions à exécuter sur les hôtes répertoriés dans l'inventaire. Toutes les tâches spécifiques que nous souhaitons automatiser sont définies dans ce playbook.

- ``roles`` : Le répertoire "roles" contient les rôles Ansible qui définissent les actions à effectuer dans notre infrastructure. Nous avons 1 rôles : "gke-cluster". Ce rôle comprend des répertoires "handlers" pour les gestionnaires d'événements, "tasks" pour les tâches spécifiques.
    - **roles/gke-cluster** : Ce rôle est chargé de se connecter au cluster GKE et d'appliquer le fichier de configuration Kubernetes permettant de déployer l'application au sein du cluster et de l'exposer a l'aide d'un Load-Balancer.

- ``vars.ym`` : Le fichier "vars.yml" est un fichier de variables Ansible. Il contient des variables globales et spécifiques au rôle qui peuvent être utilisées dans les playbooks et les tâches Ansible. **== CONFIGURABLE**

## Composition et Configuration du dossier Terrafrom

- ``gke-cluster`` : Ce répertoire contient les fichiers spécifiques à la création d'un cluster GKE.
    - **main.tf** : Ce fichier définit la configuration principale pour la création d'un cluster GKE, y compris les détails tels que le type de machine, l'image, et les paramètres réseau.
    - **outputs.tf** : Ce fichier définit les sorties (outputs) que vous souhaitez obtenir après la création du cluster GKE.
    - **variables.tf** : Ce fichier contient les déclarations de variables spécifiques du cluster GKE **== CONFIGURABLE**

- ``firewall`` : Ce répertoire contient les fichiers pour la configuration des règles de pare-feu.
    - **main.tf** : Ce fichier définit la configuration des règles de pare-feu pour votre infrastructure.
    - **outputs.tf** : Il définit les sorties liées aux règles de pare-feu.
    - **variables.tf** Ce fichier contient les déclarations de variables spécifiques aux règles de pare-feu **== CONFIGURABLE**

- ``main.tf`` : Ce fichier principal de Terraform contient la configuration générale du projet, telle que la définition du fournisseur de cloud, et des modules deployés.
- ``outputs.tf`` : Ce fichier définit les sorties globales que vous souhaitez obtenir après le déploiement de l'ensemble de l'infrastructure.

- ``service_account`` : Ce répertoire contient les fichiers liés à la configuration du compte de service.
    - **main.tf** : Il définit la configuration liée au compte de service, généralement utilisé pour gérer les autorisations dans l'infrastructure cloud.
    - **outputs.tf** : Ce fichier définit les sorties liées au compte de service.
    - **variables.tf** : Vous pouvez personnaliser les variables liées au compte de service en fonction de vos besoins.**== CONFIGURABLE**

- **terraform.tfstate** et **terraform.tfstate.backup** : Ces fichiers stockent l'état actuel de votre infrastructure Terraform. Ne les modifiez pas manuellement, car Terraform les gère automatiquement.

- **variables.tf** : Ce fichier principal contient les déclarations de variables globales pour votre projet Terraform. Vous pouvez personnaliser ces variables en fonction de vos besoins spécifiques. **== CONFIGURABLE**

- ``vpc`` : Ce répertoire contient les fichiers spécifiques à la création de votre réseau virtuel (VPC).
    - **main.tf** : Il définit la configuration pour la création du VPC, y compris les sous-réseaux et les règles de sécurité.
    - **outputs.tf** : Ce fichier définit les sorties liées au VPC.
    - **variables.tf** : Vous pouvez personnaliser les variables relatives au VPC pour répondre aux exigences de votre projet.

## Composition et Configuration des scripts Bash

* ``creation-inventory.sh`` : Ce script génère un fichier d'inventaire Ansible dynamique à partir de l'infrastructure déployé par Terraform.

* >> deploy.sh : Ce script est le SCRIPT principal pour déployer l'infrastructure.

* terraform-destroy.sh : Ce script est  utilisé pour détruire l'infrastructure que vous avez créée à l'aide de Terraform.

---

## Déploiement de l'infrastructure:

Une fois que vous avez effectué ces modifications des variables pour l'ensemble des dossiers, vous pouvez exécuter les scripts Terraform et Ansible pour déployer et configurer du cluster GKE sur GCP en utilisant la commande suivante :

``` sh
    bash deploy.sh
```

## Script bash deploy.sh pour déployer une infrastructure GCP et une application WordPress

Le script bash `deploy.sh` est un script de déploiement automatisé pour déployer une infrastructure sur Google Cloud Platform (GCP) et déployer un cluster GKE à l'aide de Terraform et Ansible.

## Description étape par étape :

### Étape 1/8: Définition et Configuration du projet GCP

* Définit la variable d'environnement `GCP_PROJECT` pour le projet GCP à utiliser.
* Configure le projet GCP en utilisant la commande `gcloud config set project`.

### Étape 2/8: Vérification de la présence de la clé ssh et Génération si nécessaire

* Vérifie si le dossier `.ssh` existe dans le répertoire personnel de l'utilisateur et le crée s'il n'existe pas.
* Vérifie si une clé SSH existe déjà dans le dossier `.ssh` et génère une nouvelle clé si elle n'existe pas.

### Étape 3/8: Vérification de Terraform et Installation si nécessaire

* Vérifie si Terraform est installé, et s'il ne l'est pas, installe Terraform en ajoutant le référentiel HashiCorp et en utilisant `apt` pour l'installation.

### Étape 4/8: Initialisation de Terraform et Création des machines

* Initialise Terraform s'il s'agit de la première exécution du script.
* Utilise Terraform pour créer des machines virtuelles en utilisant le fichier de configuration Terraform.

### Étape 5/8: Génération des inventaires dynamiques Ansible

* Génère un fichier d'inventaire dynamique `inventory.ini` contenant les adresses IP externes des VM déployées par Terraform.
* Met à jour le fichier `vars.yml` avec les adresses IP internes des ressources par Terraform.

### Étape 6/8: Vérification de Ansible et Installation si nécessaire

* Vérifie si Ansible est installé, et s'il ne l'est pas, installe Ansible en utilisant `apt`.

### Étape 7/8: Déploiement avec Ansible

* Déploie une application en utilisant Ansible à l'aide du fichier `playbook.yml` en utilisant l'inventaire `inventory.ini`.

---

## Destruction de l'infrastructure:

Pour détruire l'infrastructure que vous avez créée à l'aide de Terraform, exécutez le script ``terraform-destroy.sh`` en utilisant la commande suivante :

``` sh
    bash terraform-destroy.sh
```

>> ENJOY !
