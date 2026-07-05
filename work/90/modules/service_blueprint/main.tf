locals {
  service_id           = "${var.service_name}-${var.environment}"
  service_summary      = "${var.service_name}::${var.environment}::${var.owner}"
  module_source_style  = "local-path-module"
  module_contract_note = "This child module is called from the root module through a local source path."
}

resource "terraform_data" "service" {
  input = {
    service_id           = local.service_id
    service_summary      = local.service_summary
    module_source_style  = local.module_source_style
    module_contract_note = local.module_contract_note
  }
}
