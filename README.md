# TP6-monitoring

Documentation de la Solution de Supervision Kubernetes

1- Présentation:

Cette documentation décrit la mise en place d'une solution de supervision centralisée pour surveiller un cluster Kubernetes et les applications qu'il contient. La solution utilise Prometheus pour la collecte de métriques, Grafana pour la visualisation des tableaux de bord et les Exporters nécessaires pour récupérer les métriques des différentes composantes du cluster et des applications.

2- Arborescence des Fichiers



3- Prérequis :

Avant de déployer la solution de supervision, assurez-vous que :

    - Le cluster Kubernetes est déjà déployé et prêt à recevoir de nouveaux déploiements.
    - Vous disposez d'un accès administrateur pour créer des Déploiements, Services et ConfigMaps dans le cluster.

![supervision-app](schema/supervision-app.drawio.jpg)

4- Déploiement :
Pour déployer la solution de supervision, suivez les étapes ci-dessous :

    a- Déployez Prometheus, Grafana et les Exporters :

        - kubectl apply -f prometheus/prometheus.yaml
        - kubectl apply -f grafana/grafana.yaml
        - kubectl apply -f exporters/

    b- Déployez les applications de démonstration (Nginx et MySQL) :

        - kubectl apply -f applications/

5- Configuration :
La configuration de la solution de supervision se trouve dans les fichiers YAML suivants :

    - prometheus/prometheus.yaml : Déploiement de Prometheus.
    - prometheus/prometheus-config.yaml : Configuration Prometheus (prometheus.yml).
    - grafana/grafana.yaml : Déploiement de Grafana.
    - grafana/dashboards/ : Fichiers JSON des tableaux de bord Grafana.
    - exporters/ : Déploiements des Exporters Prometheus pour récupérer les métriques.
    - applications/ : Déploiements des applications de démonstration (Nginx et MySQL).
    - alerts/ : Fichiers YAML des alertes Prometheus.

6- Métriques Importantes :
Les métriques collectées sont liées aux quatre Signaux d'Or :

    a- Latence
    b- Utilisation CPU
    c- Utilisation Mémoire
    d- Saturation des Ressources

Les métriques collectées incluent celles provenant de Node Exporter, Kube State Metrics Exporter, Nginx Exporter, MySQL Exporter, etc.

7- Utilisation des Tableaux de Bord :
Pour utiliser les tableaux de bord fournis avec Grafana :

    a- Déployez les fichiers JSON des tableaux de bord via l'interface Grafana.
    b- Explorez les tableaux de bord pour surveiller les différentes composantes du cluster et des applications.

8- Alertes :
Les alertes Prometheus sont définies dans les fichiers YAML du dossier alerts/. Les alertes importantes ont été configurées pour les métriques critiques, comme la haute utilisation CPU sur les nœuds Kubernetes.

9- Ajouter de nouvelles Métriques:
Pour ajouter des métriques d'une nouvelle application à superviser :

    a- Déployez l'Exporter Prometheus approprié pour la nouvelle application.
    b- Définissez les requêtes PromQL pour récupérer les métriques importantes de cette application.
    c- Créez des tableaux de bord Grafana pour visualiser ces métriques.

10- Conclusion :
La solution de supervision est maintenant déployée et configurée avec Prometheus pour la collecte de métriques, Grafana pour la visualisation des tableaux de bord et les Exporters pour récupérer les métriques des différentes composantes du cluster Kubernetes et des applications. Utilisez les tableaux de bord et les alertes pour surveiller la santé de votre infrastructure Kubernetes et des applications déployées.
