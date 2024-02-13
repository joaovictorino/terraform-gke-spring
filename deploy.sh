#!/bin/bash

cd terraform

# iniciar terraform (primeira execução)
terraform init

# alterar ambiente
terraform apply -auto-approve

cd ..

# compilar imagem
docker build -t springapp .

# taggear a imagem com latest
docker tag springapp:latest us-central1-docker.pkg.dev/teste-sample-388301/ar-aula-spring/springapp:latest

# login no repositorio de imagem do Artifact Registry (privado)
gcloud auth configure-docker us-central1-docker.pkg.dev

# subir imagem
docker push us-central1-docker.pkg.dev/teste-sample-388301/ar-aula-spring/springapp:latest

# obter credenciais do GKE
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
gcloud container clusters get-credentials  gke-aula-infra --region us-central1

# subir configuração da aplicação
kubectl apply -f gke/1-config
kubectl apply -f gke/2-db
kubectl apply -f gke/3-app
