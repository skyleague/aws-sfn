variable "name" {
  type = string
}

variable "file" {
  type = string
}

variable "template_parameters" {
  type    = map(string)
  default = null
}

module "sfn" {
  source = "../"

  name = var.name
  definition = {
    file                = "${abspath(path.module)}/${var.file}"
    template_parameters = var.template_parameters
  }
}
