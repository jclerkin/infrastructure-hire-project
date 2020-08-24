# KMS key
data "aws_kms_key" "infra" {
  key_id = "alias/${var.project}-infra"
}
