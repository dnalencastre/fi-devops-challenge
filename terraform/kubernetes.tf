# define a service account for use
# by the cluster
# and to access the SQL server

resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
  project      = var.project
}

#  Add the sql client role to the service account
resource "google_project_iam_member" "firestore_owner_binding" {
  project = var.project
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_service_account_key" "default" {
  service_account_id = google_service_account.default.name
}

# Create cluster and node pools

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

    # Using the default service account for simplicity
    service_account = google_service_account.default.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# Create a namespace on the cluster and add the service account as a secret

data "google_client_config" "current" {
}

provider "kubernetes" {
  # load_config_file = false
  host                   = "https://${google_container_cluster.primary.endpoint}"
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token

}


resource "kubernetes_namespace" "duarte-test-app" {
  metadata {

    labels = {
      name = "duarte-test-app"
    }

    name = "duarte-test-app"
  }

  # trying to get this to be destroyed before the cluster is destroyed
  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary_preemptible_nodes
  ]
}

resource "kubernetes_secret" "gcp-service-account" {
  metadata {
    name = "google-application-credentials"
    namespace = kubernetes_namespace.duarte-test-app.metadata.0.name

  }
  data = {
    "credentials.json" = "${base64decode(google_service_account_key.default.private_key)}"
  }


}
