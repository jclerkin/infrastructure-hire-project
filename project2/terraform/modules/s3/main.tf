##############################################################
#  Vulnerability reporting bucket
##############################################################
resource "aws_s3_bucket" "vulnerability_reporting" {
  bucket = "${var.project}-vulnerability-reporting"
  policy = data.aws_iam_policy_document.vulnerability_reporting.json

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = data.aws_kms_key.infra.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    name      = "${var.project}-vulnerability-reporting"
    project   = var.project
    terraform = "true"
    env       = var.env
  }
}

# Block public accesss
resource "aws_s3_bucket_public_access_block" "vulnerability_reporting" {
  bucket = aws_s3_bucket.vulnerability_reporting.id

  block_public_acls   = true
  block_public_policy = true
}
