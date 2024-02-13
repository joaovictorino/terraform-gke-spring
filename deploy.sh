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
docker tag springapp:latest us-east1-docker.pkg.dev/teste-sample-388301/ar-aula-spring/springapp:latest

# login no repositorio de imagem do Artifact Registry (privado)
<<<<<<< HEAD
gcloud auth configure-docker us-east1-docker.pkg.dev
=======
gcloud auth configure-docker us-central1-docker.pkg.dev --quiet
>>>>>>> 3db0556 (initial commit)

# subir imagem
docker push us-east1-docker.pkg.dev/teste-sample-388301/ar-aula-spring/springapp:latest

# obter credenciais do GKE
<<<<<<< HEAD
gcloud container clusters get-credentials  gke-aula-infra --region us-east1
=======
gcloud container clusters get-credentials gke-aula-infra --region us-central1 --quiet
>>>>>>> 3db0556 (initial commit)

# subir configuração da aplicação
kubectl apply -f gke/1-config
kubectl apply -f gke/2-db
kubectl apply -f gke/3-app
