data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

####################################
# Define an IAM policy document here
####################################
data "aws_iam_policy_document" "s3" {
  statement {
    sid     = "s3Get"
    effect  = "Allow"
    actions = [
                "s3:GetObject"
              ]
    resources = ["${data.aws_s3_bucket.vulnerability_reporting.arn}/*"]
  }

  statement {
    sid     = "s3Put"
    effect  = "Allow"
    actions = [
                "s3:PutObject"
              ]
    resources = ["${data.aws_s3_bucket.vulnerability_reporting.arn}/outbound/*"]
  }

  statement {
    sid     = "kms"
    effect  = "Allow"
    actions = [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:GenerateDataKey"
              ]
    resources = [data.aws_kms_key.infra.arn]
  }

  statement {
    sid     = "sqs"
    effect  = "Allow"
    actions = [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage"
              ]
    resources = [data.aws_sqs_queue.vulnerability_reporting.arn]
  }
}

# ECR repo
data "aws_ecr_repository" "vulnerability_reporting" {
  name = "${var.project}-vulnerability-report"
}

# KMS key
data "aws_kms_key" "infra" {
  key_id = "alias/${var.project}-infra"
}

# SQS queue
data "aws_sqs_queue" "vulnerability_reporting" {
  name = "${var.project}-vulnerability-reporting"
}

# S3 bucket
data "aws_s3_bucket" "vulnerability_reporting" {
  bucket = "${var.project}-vulnerability-reporting"
}

# Metrics server
data "template_file" "values_metrics_server" {
  template = file("values_metrics_server.yaml.tpl")
  vars = {
    metrics_server_version = "v0.3.6"
  }
}
