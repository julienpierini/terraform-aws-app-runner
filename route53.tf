data "aws_route53_zone" "this" {
  for_each     = { for key, value in var.app_runner : key => value if value.zone_name != null }
  name         = each.value.zone_name
  private_zone = each.value.private_zone == null ? false : each.value.private_zone
}

resource "aws_route53_record" "this" {
  for_each = { for key, value in var.app_runner : key => value.zone_name if value.zone_name != null }

  zone_id = data.aws_route53_zone.this[each.key].zone_id
  name    = "${each.key}.${data.aws_route53_zone.this[each.key].name}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_apprunner_service.this[each.key].service_url]
}
