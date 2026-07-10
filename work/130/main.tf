# Lab 130 知识点总结：
# - Health Assessments 是 HCP Terraform 对 workspace 进行的周期性基础设施健康评估。
# - 它包含两类评估：Drift Detection 与 Continuous Validation。
# - Drift Detection 判断真实基础设施是否偏离 Terraform configuration。
# - 云控制台手工修改安全组、标签或实例参数，是 configuration drift 的典型来源。
# - HCP 当前文档明确区分 configuration drift 与 state drift；Health Drift Detection 不检测 state drift。
# - Continuous Validation 判断配置中的自定义断言在资源创建后是否持续成立。
# - HTTP 200、证书未过期、API 健康等运行期条件属于 Continuous Validation。
# - Continuous Validation 会评估 check blocks、preconditions 和 postconditions；官方推荐 check block 做 post-apply monitoring。
# - check block 失败会报告 warning，不会直接阻断当前 plan/apply。
# - Health Assessment 使用非 actionable 的评估计划，不会自动修改 infrastructure、state 或 configuration。
# - 发现 drift 后仍需人工决策：覆盖外部变更，或者把认可的变更写回 Terraform configuration。
# - Workspace 必须使用 Remote 或 Agent execution mode；Local execution mode 不符合要求。
# - Drift Detection 至少需要 Terraform 0.15.4；Continuous Validation 至少需要 Terraform 1.3.0。
# - Workspace 至少要有一次成功 apply，且最新 run 必须成功；最新 run 失败时评估会暂停。
# - 普通 read access 可以查看 health status；修改 workspace health 设置或触发按需评估需要 workspace admin。
# - Organization owner 可以强制所有符合条件的 workspaces 启用 Health Assessments。
# - 可配置 Drift detected、Check failed 和 Assessment errored 等通知，但通知本身不会修复问题。
# - Health Assessments 当前属于 HCP Terraform Standard 和 Premium editions。
#
# 本 Lab 是概念、选择与判断题，不连接 HCP Terraform，也不执行真实 HTTP、云资源或定时任务。
# 请完成四组判断；每个 TODO 都有可以直接替换的完整答案级 Hint。

terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：根据场景选择 Drift Detection 或 Continuous Validation。
  # 答案级 Hint：完整答案如下：
  # assessment_type_choices = {
  #   console_changed_security_group = "drift_detection"
  #   website_returns_500            = "continuous_validation"
  #   certificate_expired            = "continuous_validation"
  #   actual_differs_from_config      = "drift_detection"
  #   state_drift_only                = "not_health_drift_detection"
  # }
  assessment_type_choices = {
    console_changed_security_group = "continuous_validation"
    website_returns_500            = "drift_detection"
    certificate_expired            = "drift_detection"
    actual_differs_from_config     = "terraform_fmt"
    state_drift_only               = "always_detected_as_configuration_drift"
  }

  # TODO 2：判断 Health Assessment 的执行与修复行为。
  # 答案级 Hint：完整答案如下：
  # assessment_behaviors = {
  #   runs_periodically          = true
  #   changes_infrastructure     = false
  #   updates_state_automatically = false
  #   interrupts_active_runs     = false
  #   alert_equals_remediation   = false
  # }
  assessment_behaviors = {
    runs_periodically           = false
    changes_infrastructure      = true
    updates_state_automatically = true
    interrupts_active_runs      = true
    alert_equals_remediation    = true
  }

  # TODO 3：判断 Continuous Validation 与 check block 的边界。
  # 答案级 Hint：完整答案如下：
  # validation_judgements = {
  #   evaluates_check_blocks       = true
  #   evaluates_pre_postconditions = true
  #   check_recommended_post_apply = true
  #   failed_check_blocks_block_apply = false
  #   evaluates_after_provisioning = true
  # }
  validation_judgements = {
    evaluates_check_blocks          = false
    evaluates_pre_postconditions    = false
    check_recommended_post_apply    = false
    failed_check_blocks_block_apply = true
    evaluates_after_provisioning    = false
  }

  # TODO 4：判断启用条件、权限与 drift 处理方式。
  # 答案级 Hint：完整答案如下：
  # readiness_and_response = {
  #   execution_modes          = "remote_or_agent"
  #   successful_apply_needed  = true
  #   failed_latest_run_pauses = true
  #   view_health_permission   = "workspace_read"
  #   on_demand_permission     = "workspace_admin"
  #   unwanted_drift_action    = "plan_and_apply_to_restore_configuration"
  #   accepted_drift_action    = "update_configuration_then_apply"
  # }
  readiness_and_response = {
    execution_modes          = "local_only"
    successful_apply_needed  = false
    failed_latest_run_pauses = false
    view_health_permission   = "organization_owner_only"
    on_demand_permission     = "workspace_read"
    unwanted_drift_action    = "edit_state_by_hand"
    accepted_drift_action    = "ignore_configuration_forever"
  }
}

output "assessment_type_choices" {
  description = "Health assessment type selected for each infrastructure scenario."
  value       = local.assessment_type_choices
}

output "assessment_behaviors" {
  description = "Scheduling, non-actionable execution, and remediation behavior."
  value       = local.assessment_behaviors
}

output "validation_judgements" {
  description = "Continuous Validation and check-block behavior."
  value       = local.validation_judgements
}

output "readiness_and_response" {
  description = "Workspace requirements, permissions, and drift response choices."
  value       = local.readiness_and_response
}
