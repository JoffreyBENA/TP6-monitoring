# TP6-monitoring

Documentation de la Solution de Supervision Kubernetes

## 1- Présentation:

Cette documentation décrit la mise en place d'une solution de supervision centralisée pour surveiller un cluster Kubernetes et les applications qu'il contient. La solution utilise Prometheus pour la collecte de métriques, Grafana pour la visualisation des tableaux de bord et les Exporters nécessaires pour récupérer les métriques des différentes composantes du cluster et des applications.

## 2- Arborescence des Fichiers

``` shell
. # Arborescence du repository
├── README.md
├── alerts
│   ├── alert.rules
│   └── kube-node-cpu-alerts.yaml
├── deploy-gke-cluster
│   ├── README.md
│   ├── ansible
│   │   ├── ansible.cfg
│   │   ├── inventory.ini
│   │   ├── playbook.yml
│   │   ├── roles
│   │   │   └── gke-cluster
│   │   │       ├── handlers
│   │   │       │   └── main.yml
│   │   │       └── tasks
│   │   │           └── main.yml
│   │   └── vars.yml
│   ├── creation-inventory.sh
│   ├── credentials.json
│   ├── deploy.sh
│   ├── terraform
│   │   ├── firewall
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── gke-cluster
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── service_account
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── terraform.tfstate
│   │   ├── terraform.tfstate.backup
│   │   ├── variables.tf
│   │   └── vpc
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       └── variables.tf
│   └── terraform-destroy.sh
├── exporter
│   ├── kube-state-metrics-deployment.yaml
│   ├── kube-state-metrics-service.yaml
│   ├── mysql-exporter-deployment.yaml
│   ├── mysql-exporter-service.yaml
│   ├── nginx-exporter-deployment.yaml
│   ├── nginx-exporter-service.yaml
│   ├── node-exporter-deployment.yaml
│   └── node-exporter-service.yaml
├── grafana
│   ├── grafana-deployment.yaml
│   └── grafana-service.yaml
├── mysql
│   ├── mysql-deployment.yaml
│   └── mysql-service.yaml
├── nginx
│   ├── nginx-deployment.yaml
│   └── nginx-service.yaml
├── prometheus
│   ├── prometheus-deployment.yaml
│   └── prometheus-service.yaml
├── schema
│   ├── supervision-app-exporters.jpg
│   ├── supervision-app.drawio
│   ├── supervision-app.drawio.pdf
│   └── supervision-app.jpg
└── tp_6_monitoring.pdf

19 directories, 52 files

```

Cette arborescence représente la structure d'un projet avec plusieurs dossiers et fichiers. Voici une explication simple de chaque partie :

1. README.md: Fichier de documentation expliquant le projet.

2. alerts/
   1. alert.rules: Fichier contenant les règles d'alerte Prometheus pour la surveillance.
   2. kube-node-cpu-alerts.yaml: Fichier YAML définissant des alertes spécifiques pour la CPU des nœuds Kubernetes.

3. deploy-gke-cluster/
   1. **README.md**: Fichier de documentation spécifique au déploiement du cluster GKE.
   2. **ansible/**: Dossier contenant les fichiers Ansible pour le déploiement et la configuration.
      1. ansible.cfg, inventory.ini, playbook.yml, vars.yml: Fichiers de configuration Ansible.
      2. roles/gke-cluster/
         1. handlers/main.yml: Fichier Ansible définissant des gestionnaires.
         2. tasks/main.yml: Fichier Ansible contenant les tâches principales.
   3. **creation-inventory.sh**: Script Bash pour la création d'un fichier d'inventaire Ansible.
   4. **credentials.json**: Fichier de clés d'identification pour l'accès à Google Cloud Platform.
   5. **deploy.sh**: Script de déploiement global du projet.
   6. **terraform/**: Dossier contenant les fichiers Terraform pour la configuration du cluster GKE.
      1. firewall/main.tf, firewall/outputs.tf, firewall/variables.tf: Configuration du pare-feu.
      2. gke-cluster/main.tf, gke-cluster/outputs.tf, gke-cluster/variables.tf: Configuration du cluster GKE.
      3. service_account/main.tf, service_account/outputs.tf, service_account/variables.tf: Configuration du compte de service.
      4. vpc/main.tf, vpc/outputs.tf, vpc/variables.tf: Configuration du réseau VPC.
      5. terraform.tfstate, terraform.tfstate.backup: Fichiers de suivi de l'état Terraform.
      6. variables.tf: Variables Terraform.
   7. **terraform-destroy.sh**: Script Bash pour détruire les ressources Terraform.

4. exporter/
Fichiers YAML définissant le déploiement et le service Kubernetes pour différents exportateurs (kube-state-metrics, MySQL, Nginx, Node

5. grafana/
Fichiers YAML définissant le déploiement et le service Kubernetes pour Grafana.

6. mysql/
Fichiers YAML définissant le déploiement et le service Kubernetes pour MySQL.

7. nginx/
Fichiers YAML définissant le déploiement et le service Kubernetes pour Nginx.

8. prometheus/
Fichiers YAML définissant le déploiement et le service Kubernetes pour Prometheus.

9. schema/
Fichiers graphiques (JPG, drawio, PDF) décrivant le schéma de surveillance de l'application.

10. tp_6_monitoring.pdf: Document PDF lié au TP 6 sur le monitoring.

Le projet est organisé de manière à regrouper les fichiers en fonction de leur fonctionnalité (déploiement, exportateurs, outils de surveillance, etc.).

## 3- Prérequis :

Avant de déployer la solution de supervision, assurez-vous que :

- Le cluster Kubernetes est déjà déployé et prêt à recevoir de nouveaux déploiements.
- Vous disposez d'un accès administrateur pour créer des Déploiements, Services et ConfigMaps dans le cluster.

## 4- Architecture :

Architecture globale:
![supervision-app](schema/supervision-app.jpg)

Focus sur fonctionnement des exporters:
![supervision-app](schema/supervision-app-exporters.jpg)

## 5- Déploiement :

Pour déployer la solution de supervision, suivez les étapes ci-dessous :

### a- Déployez les applications de démonstration (Nginx et MySQL) :

```bash
  - kubectl apply -f nginx/
#   - kubectl apply -f mysql
```

### b- Déployez Prometheus, Grafana et les Exporters :

```bash
  - kubectl apply -f exporters/
  - kubectl apply -f prometheus/
  - kubectl apply -f grafana/
```

## 6- Configuration :

La configuration de la solution de supervision se trouve dans les fichiers YAML suivants :

  - prometheus/prometheus.yaml : Déploiement de Prometheus.
  - prometheus/prometheus-config.yaml : Configuration Prometheus (prometheus.yml).
  - grafana/grafana.yaml : Déploiement de Grafana.
  - grafana/dashboards/ : Fichiers JSON des tableaux de bord Grafana.
  - exporters/ : Déploiements des Exporters Prometheus pour récupérer les métriques.
  - applications/ : Déploiements des applications de démonstration (Nginx et MySQL).
  - alerts/ : Fichiers YAML des alertes Prometheus.

## 7- Métriques Importantes :

Les métriques collectées sont liées aux quatre Signaux d'Or :

- Latence
- Utilisation CPU
- Utilisation Mémoire
- Saturation des Ressources

Les métriques collectées incluent celles provenant de Node Exporter, Kube State Metrics Exporter, Nginx Exporter, MySQL Exporter, etc.

## 8- Utilisation des Tableaux de Bord :

Pour utiliser les tableaux de bord fournis avec Grafana :

- Déployez les fichiers JSON des tableaux de bord via l'interface Grafana.
- Explorez les tableaux de bord pour surveiller les différentes composantes du cluster et des applications.

## 9- Alertes :

Les alertes Prometheus sont définies dans les fichiers YAML du dossier alerts/. Les alertes importantes ont été configurées pour les métriques critiques, comme la haute utilisation CPU sur les nœuds Kubernetes.

## 10- Ajouter de nouvelles Métriques :

Pour ajouter des métriques d'une nouvelle application à superviser :

- Déployez l'Exporter Prometheus approprié pour la nouvelle application.
- Sélectionner les métriques importantes de cette application.
- Créez des tableaux de bord Grafana pour visualiser ces métriques.

## Conclusion :
La solution de supervision est maintenant déployée et configurée avec Prometheus pour la collecte de métriques, Grafana pour la visualisation des tableaux de bord et les Exporters pour récupérer les métriques des différentes composantes du cluster Kubernetes et des applications. Utilisez les tableaux de bord et les alertes pour surveiller la santé de votre infrastructure Kubernetes et des applications déployées.

https://scribehow.com/shared/Create_a_new_alert_rule_with_a_15_minute_evaluation_interval_Copy__Bgxvgmh2Qq2pvrBa5LTOQw

https://scribehow.com/shared/Creating_a_Dashboard_and_Monitoring_Nginx_with_Prometheus__eMITCaMwRwS8G_OUr4LlHw