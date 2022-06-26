# terraform-aws-app-runner
AWS app runner module

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.13 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.13 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_apprunner_auto_scaling_configuration_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_auto_scaling_configuration_version) | resource |
| [aws_apprunner_custom_domain_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_custom_domain_association) | resource |
| [aws_apprunner_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_service) | resource |
| [aws_apprunner_vpc_connector.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_vpc_connector) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_runner"></a> [app\_runner](#input\_app\_runner) | List of app runner to create | <pre>map(object({<br>    auto_scaling_configuration = object({<br>      max_concurrency = number<br>      max_size        = number<br>      min_size        = number<br>      tags            = optional(map(string))<br>    })<br>    sg_cidr_blocks                  = optional(list(string))<br>    enable_vpc_egress_configuration = bool<br>    enabled_auto_deployments        = bool<br>    health_check_configuration = optional(object({<br>      healthy_threshold   = optional(number)<br>      interval            = optional(number)<br>      path                = optional(string)<br>      protocol            = optional(string)<br>      timeout             = optional(number)<br>      unhealthy_threshold = optional(number)<br>    }))<br>    image_configuration = object({<br>      port                  = number<br>      environment_variables = optional(map(string))<br>      start_command         = optional(string)<br>    })<br>    instance_configuration = object({<br>      cpu               = number<br>      memory            = number<br>      instance_role_arn = optional(string)<br>    })<br>    image_identifier      = string<br>    image_repository_type = string<br>    kms_key_arn           = optional(string)<br>    private_zone          = optional(bool)<br>    security_groups_ids   = optional(list(string))<br>    subnets               = optional(list(string))<br>    tags                  = map(string)<br>    vpc_id                = optional(string)<br>    zone_name             = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | name suffix to happend at the end of module resources | `string` | n/a | yes |
| <a name="input_service_linked_role_arn"></a> [service\_linked\_role\_arn](#input\_service\_linked\_role\_arn) | arn of the service linked role build.apprunner.amazonaws.com | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_runner_service_arns"></a> [app\_runner\_service\_arns](#output\_app\_runner\_service\_arns) | app runner service arns |
| <a name="output_app_runner_service_cnames"></a> [app\_runner\_service\_cnames](#output\_app\_runner\_service\_cnames) | app runner service cnames |
| <a name="output_app_runner_service_ids"></a> [app\_runner\_service\_ids](#output\_app\_runner\_service\_ids) | app runner service ids |
| <a name="output_app_runner_service_sg_arns"></a> [app\_runner\_service\_sg\_arns](#output\_app\_runner\_service\_sg\_arns) | app runner service sg arns |
| <a name="output_app_runner_service_sg_ids"></a> [app\_runner\_service\_sg\_ids](#output\_app\_runner\_service\_sg\_ids) | app runner service sg ids |
| <a name="output_app_runner_service_urls"></a> [app\_runner\_service\_urls](#output\_app\_runner\_service\_urls) | app runner service urls |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
