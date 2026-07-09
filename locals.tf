locals {

  resource_group_name = format(
    "rg-%s-%s-%s-%s",
    var.project_code,
    var.environment,
    var.resource_group_type,
    var.instance_id
  )

  storage_account_name = lower(
    format(
      "st%s%s%s",
      var.project_code,
      var.environment,
      "${var.zone_tier}${var.function_name}"
    )
  )

  private_endpoint_name = format(
    "pe-%s-%s-%s-%s-%s",
    var.project_code,
    var.environment,
    var.zone_tier,
    var.service_type,
    var.instance_id
  )

  private_service_connection_name = format(
    "psc-%s-%s-%s-%s-%s",
    var.project_code,
    var.environment,
    var.zone_tier,
    var.service_type,
    var.instance_id
  )
}