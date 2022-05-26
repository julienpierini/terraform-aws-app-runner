terraform {
  experiments      = [module_variable_optional_attrs]
  required_version = "~> 1.1.0"
  required_providers {
    aws = {
      version = "~> 4.13"
    }
    kubernetes = {
      version = "~> 2.11"
    }
  }
}
