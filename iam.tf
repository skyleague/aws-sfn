resource "aws_iam_role" "this" {
  name = var.name
  path = "/state-machines/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "states.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

data "aws_iam_policy_document" "tracing" {
  dynamic "statement" {
    for_each = var.logging_configuration != null ? [true] : []
    content {
      effect = "Allow"
      actions = [
        "logs:PutLogEvents",
        "logs:PutResourcePolicy",
      ]
      #tfsec:ignore:aws-iam-no-policy-wildcards
      resources = ["${aws_cloudwatch_log_group.this[0].arn}:*"]
    }
  }
  dynamic "statement" {
    for_each = var.logging_configuration != null ? [true] : []
    content {
      effect = "Allow"
      actions = [
        "logs:GetLogDelivery",
        "logs:UpdateLogDelivery",
        "logs:DeleteLogDelivery",
        "logs:CreateLogDelivery",
        "logs:ListLogDeliveries",
        "logs:DescribeResourcePolicies",
        "logs:DescribeLogGroups"
      ]
      #tfsec:ignore:aws-iam-no-policy-wildcards
      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = var.xray_tracing_enabled ? [true] : []
    content {
      effect = "Allow"
      actions = [
        "xray:PutTraceSegments",
        "xray:PutTelemetryRecords",
      ]
      resources = ["*"]
    }
  }
}
resource "aws_iam_role_policy" "tracing" {
  role        = aws_iam_role.this.id
  name_prefix = "tracing"
  policy      = data.aws_iam_policy_document.tracing.json
}

data "aws_iam_policy_document" "lambda_permissions" {
  count = length(local.lambda_arns) > 0 ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = local.lambda_arns
  }
}

resource "aws_iam_role_policy" "lambda_permissions" {
  count = length(local.lambda_arns) > 0 ? 1 : 0

  role        = aws_iam_role.this.name
  name_prefix = "lambda"
  policy      = data.aws_iam_policy_document.lambda_permissions[0].json
}
