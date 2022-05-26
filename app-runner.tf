resource "aws_security_group" "this" {
  for_each    = { for key, value in var.app_runner : key => value if value.security_groups_ids != [] }
  name        = "${each.key}-sg"
  description = "default security group for ${each.key}"
  vpc_id      = each.value.vpc_id

  ingress {
    description = "TLS from any source"
    from_port   = each.value.image_configuration.port
    to_port     = each.value.image_configuration.port
    protocol    = "tcp"
    cidr_blocks = (each.value.sg_cidr_blocks == null) ? ["0.0.0.0/0"] : each.value.sg_cidr_blocks
  }
  egress {
    description = "TLS from any source"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = each.value.tags
}

resource "aws_apprunner_custom_domain_association" "this" {
  for_each = { for key, value in var.app_runner : key => value.zone_name if value.zone_name != null }

  domain_name = aws_route53_record.this[each.key].fqdn
  service_arn = aws_apprunner_service.this[each.key].arn
}

resource "aws_apprunner_vpc_connector" "this" {
  for_each = { for key, value in var.app_runner : key => value if value.enable_vpc_egress_configuration == true }

  vpc_connector_name = "${each.key}-vpc-connector"
  subnets            = each.value.subnets
  security_groups    = (each.value.security_groups_ids == null ? [aws_security_group.this[each.key].id] : each.value.security_groups_ids)

  tags = each.value.tags
}

resource "aws_apprunner_auto_scaling_configuration_version" "this" {
  for_each = { for key, value in var.app_runner : key => value.auto_scaling_configuration }

  auto_scaling_configuration_name = "asc-${each.key}"

  max_concurrency = each.value.max_concurrency
  max_size        = each.value.max_size
  min_size        = each.value.min_size

  tags = (each.value.tags == null) ? {} : each.value.tags
}

resource "aws_apprunner_service" "this" {
  for_each     = var.app_runner
  service_name = "${each.key}-${var.name_suffix}"

  dynamic "encryption_configuration" {
    for_each = (each.value.kms_key_arn == null) ? [] : [1]
    content {
      kms_key = each.value.kms_key_arn
    }
  }

  instance_configuration {
    cpu               = each.value.instance_configuration.cpu
    instance_role_arn = each.value.instance_configuration.instance_role_arn
    memory            = each.value.instance_configuration.memory
  }

  health_check_configuration {
    healthy_threshold   = (each.value.health_check_configuration == null) ? 3 : lookup(each.value.health_check_configuration, "healthy_threshold", 3)
    interval            = (each.value.health_check_configuration == null) ? 5 : lookup(each.value.health_check_configuration, "interval", 5)
    path                = (each.value.health_check_configuration == null) ? "/" : lookup(each.value.health_check_configuration, "path", "/")
    protocol            = (each.value.health_check_configuration == null) ? "TCP" : lookup(each.value.health_check_configuration, "protocol", "TCP")
    timeout             = (each.value.health_check_configuration == null) ? 2 : lookup(each.value.health_check_configuration, "timeout", 2)
    unhealthy_threshold = (each.value.health_check_configuration == null) ? 5 : lookup(each.value.health_check_configuration, "unhealthy_threshold", 5)
  }

  source_configuration {
    authentication_configuration {
      access_role_arn = "arn:aws:iam::301381660126:role/service-role/AppRunnerECRAccessRole"
    }
    image_repository {
      dynamic "image_configuration" {
        for_each = (each.value.image_configuration.start_command == null) ? [] : [1]
        content {
          port                          = each.value.image_configuration.port
          runtime_environment_variables = (each.value.image_configuration.environment_variables == null) ? {} : each.value.image_configuration.environment_variable
        }
      }
      dynamic "image_configuration" {
        for_each = (each.value.image_configuration.start_command == null) ? [1] : []
        content {
          port                          = each.value.image_configuration.port
          runtime_environment_variables = (each.value.image_configuration.environment_variables == null) ? {} : each.value.image_configuration.environment_variable
          start_command                 = each.value.image_configuration.start_command
        }
      }
      image_identifier      = each.value.image_identifier
      image_repository_type = each.value.image_repository_type
    }
    auto_deployments_enabled = each.value.enabled_auto_deployments
  }

  network_configuration {
    dynamic "egress_configuration" {
      for_each = each.value.enable_vpc_egress_configuration ? [1] : []
      content {
        egress_type       = "VPC"
        vpc_connector_arn = aws_apprunner_vpc_connector.this[each.key].arn
      }
    }
    dynamic "egress_configuration" {
      for_each = each.value.enable_vpc_egress_configuration ? [] : [1]
      content {
        egress_type = "DEFAULT"
      }
    }
  }

  tags = each.value.tags
}
