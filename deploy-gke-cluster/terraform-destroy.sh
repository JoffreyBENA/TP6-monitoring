cd terraform
gcloud container clusters delete my-gke-cluster --zone=europe-west9
terraform destroy -auto-approve