##############################################################
#  State bucket policy
##############################################################
data "aws_iam_policy_document" "state" {

  # Deny incorrect encryption key
  statement {
    sid       = "DenyIncorrectEncryption"
    effect    = "Deny"
    actions   = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${var.project}-state/*"
    ]

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    condition {
      test     = "StringNotLikeIfExists"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = [aws_kms_key.state.arn]
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
      "arn:aws:s3:::${var.project}-state/*"
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
