##############################################################
#  KMS Key to encrypt state bucket
##############################################################
resource "aws_kms_key" "state" {
  description             = "${var.project} state encryption key"
  deletion_window_in_days = 10

  tags = {
    name      = "${var.project}-state"
    project   = var.project
    terraform = "true"
    env       = var.env
  }
}

resource "aws_kms_alias" "state" {
  name          = "alias/${var.project}-state"
  target_key_id = aws_kms_key.state.key_id
}


##############################################################
#  State bucket
##############################################################
resource "aws_s3_bucket" "state" {
  bucket = "${var.project}-state"
  policy = data.aws_iam_policy_document.state.json

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.state.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    name      = "${var.project}-state"
    project   = var.project
    terraform = "true"
    env       = var.env
  }
}

# Block public accesss
resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls   = true
  block_public_policy = true
}
