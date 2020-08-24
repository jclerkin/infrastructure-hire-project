# Account details
data "aws_caller_identity" "current" {}

# KMS key
data "aws_kms_key" "infra" {
  key_id = "alias/${var.project}-infra"
}

# SQS Policy
data "aws_iam_policy_document" "sqs" {
  statement {
    sid       = "First"
    effect    = "Allow"
    actions   = [
      "sqs:*"
    ]

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }

    resources = [
      aws_sqs_queue.vulnerability_reporting.arn
    ]
  }
}

# Policy document trust policy
data "aws_iam_policy_document" "s3tosqsqueue_trust" {
  statement {
    sid       = "assume"
    effect    = "Allow"
    actions   = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Lambda role policy
data "aws_iam_policy_document" "s3tosqsqueue" {
  statement {
    sid       = "logs"
    effect    = "Allow"
    actions   = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
    ]
  }

  statement {
    sid       = "s3"
    effect    = "Allow"
    actions   = [
      "s3:Get*",
      "s3:Describe*"
    ]

    resources = [
      data.aws_s3_bucket.vulnerability_reporting.arn
    ]
  }

  statement {
    sid       = "sqs"
    effect    = "Allow"
    actions   = [
      "sqs:SendMessage"
    ]

    resources = [
      aws_sqs_queue.vulnerability_reporting.arn
    ]
  }
}

# S3 bucket
data "aws_s3_bucket" "vulnerability_reporting" {
  bucket = "${var.project}-vulnerability-reporting"
}
