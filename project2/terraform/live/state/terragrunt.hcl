terraform {
  source = "../../modules/state"
}

include {
  path = find_in_parent_folders()
}
