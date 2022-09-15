resource "aws_cloudwatch_log_group" "this" {
  count             = var.logging_configuration != null ? 1 : 0
  name              = "/aws/vendedlogs/states/${var.name}-Logs"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.log_kms_key_id
}
