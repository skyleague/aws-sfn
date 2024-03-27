mock_provider "aws" {
  alias = "mock"

  override_data {
    target = module.sfn.data.aws_iam_policy_document.tracing
    values = {
      json = "{}"
    }
  }

  override_data {
    target = module.sfn.data.aws_region.current
    values = {
      name = "eu-west-1"
    }
  }
}

run "template_parameters_replaced_correctly" {
  command = plan

  providers = {
    aws = aws.mock
  }

  variables {
    name = "foo"
    file = "stubs/definition.json"
    template_parameters = {
      bar = "baz"
    }
  }

  assert {
    condition     = module.sfn.state_machine.name == "foo"
    error_message = "Name was not set correctly"
  }

  assert {
    condition     = jsondecode(module.sfn.state_machine.definition) == { foo = "baz", region = "eu-west-1" }
    error_message = "Template was not rendered correctly"
  }
}
