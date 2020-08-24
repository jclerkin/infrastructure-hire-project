resource "kubernetes_service_account" "s3" {
  metadata {
    name      = var.k8s_service_account_name
    namespace = var.k8s_service_account_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_s3.this_iam_role_arn
    }
  }
  automount_service_account_token = true
}
