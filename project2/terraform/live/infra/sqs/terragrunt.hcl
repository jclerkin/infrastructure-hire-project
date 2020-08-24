terraform {
  source = "../../../modules/sqs"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../kms", "../s3"]
}
