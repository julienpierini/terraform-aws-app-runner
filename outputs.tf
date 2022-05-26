output "app_runner_service_arns" {
  description = "app runner service arns"
  value       = { for key, value in var.app_runner : key => aws_apprunner_service.this[key].arn }
}
output "app_runner_service_ids" {
  description = "app runner service ids"
  value       = { for key, value in var.app_runner : key => aws_apprunner_service.this[key].service_id }
}
output "app_runner_service_urls" {
  description = "app runner service urls"
  value       = { for key, value in var.app_runner : key => aws_apprunner_service.this[key].service_url }
}
output "app_runner_service_cnames" {
  description = "app runner service cnames"
  value       = { for key, value in var.app_runner : key => aws_route53_record.this[key].fqdn if value.zone_name != null }
}
output "app_runner_service_sg_arns" {
  description = "app runner service sg arns"
  value       = { for key, value in var.app_runner : key => aws_security_group.this[key].arn if value.security_groups_ids != [] }
}
output "app_runner_service_sg_ids" {
  description = "app runner service sg ids"
  value       = { for key, value in var.app_runner : key => aws_security_group.this[key].id if value.security_groups_ids != [] }
}
