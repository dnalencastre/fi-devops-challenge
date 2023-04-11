terraform {
  required_providers {
    google = {
      version = "4.60.2"
    }
  }
}

provider "google" {
  project = "silent-wharf-383312"
  region  = "us-east1"
  zone    = "us-east1-b"
}
