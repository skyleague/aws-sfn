data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "external" "definition" {
  program = ["npx", "-y", "ts-node", "-T", "--skip-project", "${path.module}/scripts/src/index.ts"]

  query = {
    file         = var.definition.file
    export       = var.definition.export
    awsRegion    = data.aws_region.current.name
    awsAccountId = data.aws_caller_identity.current.account_id
  }
}
locals {
  lambda_arns = jsondecode(data.external.definition.result.lambda_arns)
  definition  = jsondecode(data.external.definition.result.definition)
}

resource "aws_sfn_state_machine" "this" {
  name       = var.name
  role_arn   = aws_iam_role.this.arn
  definition = jsonencode(local.definition)

  tracing_configuration {
    enabled = var.xray_tracing_enabled
  }
  dynamic "logging_configuration" {
    for_each = var.logging_configuration != null ? [true] : []
    content {
      include_execution_data = var.logging_configuration.include_execution_data
      level                  = var.logging_configuration.level
      log_destination        = "${aws_cloudwatch_log_group.this[0].arn}:*"
    }
  }

  depends_on = [
    aws_iam_role_policy.tracing,
  ]
}

output "state_machine" {
  value = aws_sfn_state_machine.this
}

output "role" {
  value = aws_iam_role.this
}

output "log_group" {
  value = aws_cloudwatch_log_group.this
}
