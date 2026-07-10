run "hcp_terraform_pricing_principles_are_understood" {
  command = plan

  assert {
    condition = output.delivery_models == {
      hcp_terraform        = "managed_saas"
      terraform_enterprise = "self_hosted"
      air_gapped_direction = "terraform_enterprise"
    }
    error_message = "Review TODO 1: HCP Terraform is managed SaaS; Terraform Enterprise is the self-hosted direction."
  }

  assert {
    condition = output.billing_facts == {
      primary_usage_unit            = "hourly_peak_managed_resources"
      plan_apply_count_is_main_unit = false
      repeated_change_counts_as_new = false
      partial_hour_rounds_to_full   = true
    }
    error_message = "Review TODO 2: current PAYG billing is based on hourly peak managed resources, not command or change counts."
  }

  assert {
    condition = output.scenario_answers == {
      learn_with_small_team       = "check_current_free_or_trial_options"
      need_audit_drift_validation = "check_standard_or_higher_current_matrix"
      need_air_gapped_install     = "terraform_enterprise"
      need_exact_monthly_budget   = "use_current_official_pricing_and_usage"
    }
    error_message = "Review TODO 3: choose current plan lookup, Enterprise, or live pricing according to the scenario."
  }

  assert {
    condition = output.study_strategy == {
      memorize_billing_basis       = true
      memorize_saas_vs_self_hosted = true
      memorize_fixed_usd_prices    = false
      verify_current_plan_matrix   = true
      verify_current_free_limits   = true
    }
    error_message = "Review TODO 4: learn stable principles, but verify current prices, plan features, and free limits."
  }
}
