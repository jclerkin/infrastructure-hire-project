# SQS queue
resource "aws_sqs_queue" "vulnerability_reporting" {
  name                              = "${var.project}-vulnerability-reporting"
  kms_master_key_id                 = aws_kms_key.infra.arn
  kms_data_key_reuse_period_seconds = 300
}

#	The role policy giving the lambda access to the S3 bucket
resource "aws_iam_role_policy" "s3tosqsqueue" {
  name    = "s3tosqsqueue-lambda-${var.project}-vulnerability-reporting-role-policy"
  role    = aws_iam_role.s3tosqsqueue.id
  policy  = data.aws_iam_policy_document.s3tosqsqueue.json
}

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
      aws_s3_bucket.vulnerability_reporting.arn
    ]
  }
}


resource "aws_iam_role" "s3tosqsqueue" {
  name = "s3tosqsqueue-lambda-${var.project}-vulnerability-reporting-role"
  assume_role_policy = data.aws_iam_policy_document.s3tosqsqueue_trust.json

  tags = {
    name      = "${var.project}-vulnerability-reporting"
    project   = var.project
    terraform = "true"
    env       = var.env
  }
}

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

resource "aws_kms_grant" "s3tosqsqueue" {
  name              = "s3tosqsqueue-lambda-${var.project}-vulnerability-reporting-kms-grant"
  key_id            = aws_kms_key.infra.arn
  grantee_principal = aws_iam_role.s3tosqsqueue.arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_lambda_alias" "s3tosqsqueue" {
  function_name    = aws_lambda_function.s3tosqsqueue.arn
  function_version = "$LATEST"
  name             = "${var.project}-vulnerability-reporting-s3tosqsqueue-lambda"
}

resource "aws_lambda_permission" "s3tosqsqueue" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3tosqsqueue.arn
  principal     = "s3.amazonaws.com"
  qualifier     = aws_lambda_alias.s3tosqsqueue.name
  source_arn    = aws_s3_bucket.vulnerability_reporting.arn
  statement_id  = "AllowExecutionFromS3Bucket"
}

resource "aws_s3_bucket_notification" "s3tosqsqueue" {
  bucket = aws_s3_bucket.vulnerability_reporting.id
  lambda_function {
      lambda_function_arn = aws_lambda_function.s3tosqsqueue.arn
      events              = ["s3:ObjectCreated:*"]
      filter_prefix       = "inbound/"
  }
}

resource "aws_lambda_function" "s3tosqsqueue" {
  filename         = "s3tosqsqueue-lambda.zip"
  function_name    = "${var.project}-vulnerability-reporting-s3tosqsqueue-lambda"
  role             = aws_iam_role.s3tosqsqueue.arn
  handler          = "SQSToS3Lambda.lambda_handler"
  source_code_hash = filebase64sha256("s3tosqsqueue-lambda.zip")
  runtime          = "python3.7"

  environment {
    variables = {
      queue_url = "https://sqs.${var.region}.amazonaws.com/${data.aws_caller_identity.current.account_id}/${aws_sqs_queue.vulnerability_reporting.name}"
    }
  }
  tags = {
    name      = "${var.project}-vulnerability-reporting"
    project   = var.project
    terraform = "true"
    env       = var.env
  }
}
