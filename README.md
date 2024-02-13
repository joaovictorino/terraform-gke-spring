# Terraform criando Google Kubernetes Engine (GKE)

Pré-requisitos

- gcloud instalado
- Terraform instalado

Logar no GCP via gcloud, o navegador será aberto para que o login seja feito

```sh
gcloud auth login
```

Inicializar o Terraform

```sh
terraform init
```

Executar o Terraform

```sh
terraform apply -auto-approve
```

Compilar imagem

```sh
docker build -t springapp .
```

Taggear a imagem com latest

```sh
docker tag springapp:latest us-central1-docker.pkg.dev/teste-sample-388301/ar-aula-spring/springapp:latest
```

Login no repositorio de imagem do Artifact Registry (privado)

```sh
gcloud auth configure-docker us-central1-docker.pkg.dev
```

Subir imagem

```sh
docker push us-central1-docker.pkg.dev/teste-sample-388301/ar-aula-spring/springapp:latest
```

Obter credenciais do GKE

```sh
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
gcloud container clusters get-credentials  gke-aula-infra --region us-central1
```

Subir configuração da aplicação

```sh
kubectl apply -f gke/1-config
kubectl apply -f gke/2-db
kubectl apply -f gke/3-app
```
