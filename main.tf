data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "external" "definition" {
  count = endswith(var.definition.file, ".json") ? 0 : 1
  program = flatten([
    "npx", "-y",
    # Install dependencies for npx
    [for p in setunion(["@skyleague/therefore-sfn@^1.3.6"], var.npm_package_dependencies) : ["--package", p]],

    # Execute therefore-sfn
    "therefore-sfn", "compile", var.definition.file,
    "--export", var.definition.export,
    "--aws-region", data.aws_region.current.name,
    "--aws-account-id", data.aws_caller_identity.current.account_id
  ])
}
locals {
  template_parameters = merge(coalesce(try(var.definition.template_parameters, null), {}), {
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
  file_definition = endswith(var.definition.file, ".json") ? jsondecode(templatefile(var.definition.file, local.template_parameters)) : null
  raw_definition  = endswith(var.definition.file, ".json") ? local.file_definition : data.external.definition[0].result
  lambda_arns     = jsondecode(local.raw_definition.lambda_arns)
  definition      = jsondecode(local.raw_definition.definition)
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
