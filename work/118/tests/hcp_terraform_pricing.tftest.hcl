run "hcp_terraform_pricing_concepts_are_modeled" {
  command = plan

  assert {
    condition = output.plan_names == [
      "Essentials",
      "Standard",
      "Premium",
      "Enterprise Self-Managed"
    ]
    error_message = "plan_names must list all pricing plans from data/pricing.json in order."
  }

  assert {
    condition     = output.plans_by_name["Essentials"].relative_cost_rank == 1
    error_message = "plans_by_name must be keyed by plan name and preserve Essentials data."
  }

  assert {
    condition     = output.plans_by_name["Premium"].delivery == "hcp_managed"
    error_message = "plans_by_name must preserve Premium as an HCP managed plan."
  }

  assert {
    condition     = output.plans_without_audit_logging == ["Essentials"]
    error_message = "Only Essentials should be reported as missing audit_logging in this mock dataset."
  }

  assert {
    condition     = output.air_gapped_plan_names == ["Enterprise Self-Managed"]
    error_message = "air_gapped_plan_names must identify Enterprise Self-Managed only."
  }

  assert {
    condition = output.billing_model_names == [
      "Pay As You Go",
      "Flex",
      "Enterprise Self-Managed"
    ]
    error_message = "billing_model_names must be read from pricing.billing_models."
  }

  assert {
    condition = output.exam_summary == {
      entry_plan                        = "Essentials"
      highest_hcp_managed_plan          = "Premium"
      has_pay_as_you_go                 = true
      air_gapped_is_enterprise_only     = true
    }
    error_message = "exam_summary must capture the core pricing exam concepts from this lab."
  }
}
