variable "region" {
  description = "AWS region"
}

variable "project" {
  description = "Project name"
}

variable "env" {
  description = "Environment"
}

variable "cluster_name" {
  description = "Cluster name"
}

variable "k8s_service_account_namespace" {
  description = "Service account namespace"
}

variable "k8s_service_account_name" {
  description = "Service account name"
}

variable "image_version" {
  description = "container image version"
}
