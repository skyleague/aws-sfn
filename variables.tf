variable "definition" {
  description = "JSON definition of the Stepfunction"
  type = object({
    file   = string
    export = string
  })
}
variable "name" {
  description = "Name of the Stepfunction"
  type        = string
}
variable "log_retention_in_days" {
  description = "Log retention for access logs and execution logs (set to 0 or `null` to never expire)"
  type        = number
  default     = 14
}
variable "log_kms_key_id" {
  description = "Custom KMS key for log encryption"
  type        = string
  default     = null
}
variable "xray_tracing_enabled" {
  description = "Enable XRay Tracing"
  type        = bool
  default     = true
}
variable "logging_configuration" {
  description = "Logging configuration for the Stepfunction"
  type = object({
    include_execution_data = bool
    level                  = string
  })
  default = {
    include_execution_data = false
    level                  = "ALL"
  }
}
