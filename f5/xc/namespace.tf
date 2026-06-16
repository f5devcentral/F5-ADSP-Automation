resource "null_resource" "namespace_mode" {
  triggers = {
    mode = data.volterra_namespace.existing.id == "" ? "create" : "use_existing"
  }

  lifecycle {
    # Keep the first detected mode to avoid flipping from create -> use_existing on later applies.
    ignore_changes = [triggers]
  }
}

resource "volterra_namespace" "this" {
  count = null_resource.namespace_mode.triggers.mode == "create" ? 1 : 0
  name  = var.xc_namespace
}
