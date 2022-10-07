locals {
  parameter_config         = "-config ${var.pan_creds}"
  parameter_mode           = "-mode '${var.mode}'"
  parameter_device_group   = var.device_group != null ? "-deviceGroup '${var.device_group}'" : ""
  parameter_devices        = var.devices != null ? "-devices '${var.devices}' " : ""
  parameter_template_stack = var.template_stack != null ? "-templateStack '${var.template_stack}'" : ""
}

resource "null_resource" "panorama_commit_push_binary" {
  triggers = {
    configured_resource_ids = var.configured_resource_ids
  }

  provisioner "local-exec" {
    command = "${var.panorama_commit_push_binary} ${local.parameter_config} ${local.parameter_mode} ${local.parameter_device_group} ${local.parameter_devices} ${local.parameter_template_stack}"
  }
}