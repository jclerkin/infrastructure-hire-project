# S3 bucket policy
data "aws_iam_policy_document" "vulnerability_reporting" {

  # Deny incorrect encryption key
  statement {
    sid       = "DenyIncorrectEncryption"
    effect    = "Deny"
    actions   = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${var.project}-vulnerability-reporting/*"
    ]

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    condition {
      test     = "StringNotLikeIfExists"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = [data.aws_kms_key.infra.arn]
    }
  }

  # Deny unencrypted object uploads
  statement {
    sid       = "DenyUnEncryptedObjectUploads"
    effect    = "Deny"
    actions   = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${var.project}-vulnerability-reporting/*"
    ]

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["true"]
    }
  }
}

# KMS key
data "aws_kms_key" "infra" {
  key_id = "alias/${var.project}-infra"
}
