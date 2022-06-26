variable "app_runner" {
  description = "List of app runner to create"
  type = map(object({
    auto_scaling_configuration = object({
      max_concurrency = number
      max_size        = number
      min_size        = number
      tags            = optional(map(string))
    })
    sg_cidr_blocks                  = optional(list(string))
    enable_vpc_egress_configuration = bool
    enabled_auto_deployments        = bool
    health_check_configuration = optional(object({
      healthy_threshold   = optional(number)
      interval            = optional(number)
      path                = optional(string)
      protocol            = optional(string)
      timeout             = optional(number)
      unhealthy_threshold = optional(number)
    }))
    image_configuration = object({
      port                  = number
      environment_variables = optional(map(string))
      start_command         = optional(string)
    })
    instance_configuration = object({
      cpu               = number
      memory            = number
      instance_role_arn = optional(string)
    })
    image_identifier      = string
    image_repository_type = string
    kms_key_arn           = optional(string)
    private_zone          = optional(bool)
    security_groups_ids   = optional(list(string))
    subnets               = optional(list(string))
    tags                  = map(string)
    vpc_id                = optional(string)
    zone_name             = optional(string)
  }))
}
variable "name_suffix" {
  description = "name suffix to happend at the end of module resources"
  type        = string
}

variable "service_linked_role_arn" {
  description = "arn of the service linked role build.apprunner.amazonaws.com"
  type        = string
  default     = null
}
