# Lab 118 知识点总结：
# - HCP Terraform 是托管 SaaS，当前同时存在 Free organization 和多个付费 edition。
# - 当前付费层级常见为 Essentials、Standard、Premium；较高付费层级包含较低层级的能力。
# - Terraform Enterprise 是自托管产品，适合需要私有部署、最大控制或隔离环境的组织。
# - HCP Terraform 的 PAYG 定价重点是 managed resources（也称 RUM），不是 plan/apply 命令次数。
# - 当前官方定义按每小时的 managed resource 峰值计费，部分小时按完整小时计算。
# - 同一个资源反复修改不会因为修改次数多就自动变成多个 managed resources。
# - audit logging、drift detection、continuous validation 等属于更高级的平台治理能力。
# - 套餐名称、美元单价、免费额度和 feature matrix 都可能变化，不能把课程截图当永久事实。
# - 考试应记“计费与能力分类原则”；做采购预算时必须查看当前官方 pricing 页面。
#
# 本 Lab 不连接 HCP Terraform，也不要求购买套餐。
# 四组概念与场景判断均已完成，下面保留参考答案供复习。

terraform {
  required_version = ">= 1.5.0"
}

locals {
  # 已完成 1：区分 HCP Terraform 与 Terraform Enterprise。
  # 参考答案如下：
  # delivery_models = {
  #   hcp_terraform       = "managed_saas"
  #   terraform_enterprise = "self_hosted"
  #   air_gapped_direction = "terraform_enterprise"
  # }
  delivery_models = {
    hcp_terraform        = "managed_saas"
    terraform_enterprise = "self_hosted"
    air_gapped_direction = "terraform_enterprise"
  }

  # 已完成 2：判断当前 managed resource 计费原则。
  # 参考答案如下：
  # billing_facts = {
  #   primary_usage_unit             = "hourly_peak_managed_resources"
  #   plan_apply_count_is_main_unit  = false
  #   repeated_change_counts_as_new  = false
  #   partial_hour_rounds_to_full    = true
  # }
  billing_facts = {
    primary_usage_unit            = "hourly_peak_managed_resources"
    plan_apply_count_is_main_unit = false
    repeated_change_counts_as_new = false
    partial_hour_rounds_to_full   = true
  }

  # 已完成 3：为采购/架构场景选择正确方向。
  # 参考答案如下：
  # scenario_answers = {
  #   learn_with_small_team       = "check_current_free_or_trial_options"
  #   need_audit_drift_validation = "check_standard_or_higher_current_matrix"
  #   need_air_gapped_install     = "terraform_enterprise"
  #   need_exact_monthly_budget   = "use_current_official_pricing_and_usage"
  # }
  scenario_answers = {
    learn_with_small_team       = "check_current_free_or_trial_options"
    need_audit_drift_validation = "check_standard_or_higher_current_matrix"
    need_air_gapped_install     = "terraform_enterprise"
    need_exact_monthly_budget   = "use_current_official_pricing_and_usage"
  }

  # 已完成 4：区分应记忆的原则与必须实时核对的信息。
  # 参考答案如下：
  # study_strategy = {
  #   memorize_billing_basis       = true
  #   memorize_saas_vs_self_hosted = true
  #   memorize_fixed_usd_prices    = false
  #   verify_current_plan_matrix   = true
  #   verify_current_free_limits   = true
  # }
  study_strategy = {
    memorize_billing_basis       = true
    memorize_saas_vs_self_hosted = true
    memorize_fixed_usd_prices    = false
    verify_current_plan_matrix   = true
    verify_current_free_limits   = true
  }
}

output "delivery_models" {
  description = "Managed SaaS versus self-hosted delivery models."
  value       = local.delivery_models
}

output "billing_facts" {
  description = "Stable managed-resource billing principles."
  value       = local.billing_facts
}

output "scenario_answers" {
  description = "Pricing and delivery direction selected for each scenario."
  value       = local.scenario_answers
}

output "study_strategy" {
  description = "Which pricing facts to learn and which to verify live."
  value       = local.study_strategy
}
