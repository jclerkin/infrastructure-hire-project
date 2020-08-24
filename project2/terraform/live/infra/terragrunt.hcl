remote_state {
  backend = "s3"
  config = {
    bucket         = "project2-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    kms_key_id = "arn:aws:kms:us-east-1:362769085115:key/acf57af1-3a71-4dc9-9fe4-381e7c3c887d"
  }
}

inputs = {
  # Project Variables
  region = "us-east-1",
  project = "project2",
  env = "prod"

  # EKS variables
  cluster_name                  = "contrast-example"
  k8s_service_account_namespace = "default"
  k8s_service_account_name      = "s3"
  image_version                 = "v0.1.3"
}
