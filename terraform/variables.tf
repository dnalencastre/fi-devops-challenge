variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "project" {
  type = string
}

variable "kubernetes_cluster_name" {
  type = string
}

variable "db_instance_name" {
  type = string
}

variable "db_user_name" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_instance_size" {
  type = string
}

variable "db_version" {
  type = string
}

variable "kubernetes_node_count" {
  type = number
}

variable "kubernetes_node_size" {
  type = string
}