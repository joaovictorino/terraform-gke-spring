terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.51.0"
    }
  }

  required_version = ">= 0.14"
}

variable "region" {
  default = "us-east1"
  type    = string
}

provider "google" {
  project = "teste-sample-388301"
  region  = var.region
}

resource "google_artifact_registry_repository" "ar-aula-spring" {
  location      = var.region
  repository_id = "ar-aula-spring"
  format        = "DOCKER"
}

resource "google_compute_network" "vpc" {
  name                    = "vpc-gke"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-gke"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

resource "google_project_service" "container" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_container_cluster" "primary" {
  name     = "gke-aula-infra"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false
  network                  = google_compute_network.vpc.name
  subnetwork               = google_compute_subnetwork.subnet.name
}

resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    service_account = google_service_account.default.email
    preemptible     = true
    machine_type    = "e2-medium"
  }
}

resource "google_artifact_registry_repository_iam_binding" "binding" {
  project    = google_artifact_registry_repository.ar-aula-spring.project
  location   = google_artifact_registry_repository.ar-aula-spring.location
  repository = google_artifact_registry_repository.ar-aula-spring.name
  role       = "roles/artifactregistry.reader"
  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
}
