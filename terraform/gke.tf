resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
  project      = var.project
}

resource "google_container_cluster" "primary" {
  name     = var.kubernetes_cluster_name
  location   = var.zone
  project    = var.project
  
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = "default"
}


resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = var.zone
  project    = var.project
  cluster    = google_container_cluster.primary.name
  node_count = var.kubernetes_node_count

  node_config {
    preemptible  = true
    machine_type = var.kubernetes_node_size

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}