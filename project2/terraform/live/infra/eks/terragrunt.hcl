terraform {
  source = "../../../modules/eks"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../kms", "../s3", "../sqs"]
}
