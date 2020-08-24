terraform {
  source = "../../../modules/kms"
}

include {
  path = find_in_parent_folders()
}
