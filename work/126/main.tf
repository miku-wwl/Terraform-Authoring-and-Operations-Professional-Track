# Lab 126 知识点总结：
# - Sentinel 是 HashiCorp 的 policy as code 框架；HCP Terraform 也支持 OPA。
# - Policy 是一条治理规则，例如限制部署区域、实例规格或必需标签。
# - Policy Set 是一组同一 policy framework 的 policies，并负责把它们应用到目标范围。
# - Policy Set 可应用到整个 organization、指定 project/workspace，或使用目前为 Beta 的 workspace tags 范围。
# - HCP Terraform 推荐把 policy code 保存在 VCS，以获得版本、评审和审计记录。
# - Sentinel policy check 只在 terraform plan 成功后执行，并发生在 apply 之前。
# - 当前默认 policy-check 流程中，Sentinel 检查在 post-plan run tasks 和 cost estimation 之后。
# - advisory 失败只产生警告，不阻止 run 继续。
# - soft-mandatory 失败会暂停 run；具有 policy override 权限的人员可以覆盖。
# - hard-mandatory 必须通过，不能在该 run 中 override。
# - Enforcement level 与 policy 逻辑分离；同一条规则部署时可以选择不同强制级别。
# - Policy Set 关联到 workspace 后，会检查该 workspace 的每次适用 Terraform run。
# - Sentinel 能检查 Terraform run 的配置、plan、state 或 run 信息，但不是云平台的实时防火墙。
# - 绕过 Terraform 在云控制台创建的资源，不会因为 Sentinel policy 而自动被阻止。
# - 云侧 drift、手工变更和持续合规仍需要云平台控制、审计或其他合规工具。
# - HCP Terraform Free 当前包含一个最多五条 policy 的 policy set，不能再简单记成“Sentinel 必须付费”。
#
# 本 Lab 是概念、选择与判断题，不连接 HCP Terraform，也不编写或执行真实 Sentinel policy。
# 请完成四组判断；每个 TODO 都有可以直接替换的完整答案级 Hint。

terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：区分 Sentinel、Policy 和 Policy Set 的职责。
  # 答案级 Hint：完整答案如下：
  # policy_model = {
  #   sentinel          = "policy_as_code_framework"
  #   policy            = "single_governance_rule"
  #   policy_set        = "collection_and_scope_assignment"
  #   primary_input     = "terraform_run_data"
  #   runs_before_apply = true
  # }
  policy_model = {
    sentinel          = "terraform_provider"
    policy            = "workspace_state_backend"
    policy_set        = "collection_of_variables"
    primary_input     = "cloud_console_events_only"
    runs_before_apply = false
  }

  # TODO 2：为三种 Sentinel enforcement level 选择正确行为。
  # 答案级 Hint：完整答案如下：
  # enforcement_choices = {
  #   advisory       = "warn_and_continue"
  #   soft_mandatory = "pause_until_authorized_override_or_discard"
  #   hard_mandatory = "must_pass_and_cannot_be_overridden"
  #   configured_in  = "policy_deployment"
  # }
  enforcement_choices = {
    advisory       = "always_block_apply"
    soft_mandatory = "ignore_failure"
    hard_mandatory = "any_user_can_override"
    configured_in  = "terraform_provider_block"
  }

  # TODO 3：判断 Policy Set 的作用域、框架和交付方式。
  # 答案级 Hint：完整答案如下：
  # policy_set_judgements = {
  #   can_apply_globally             = true
  #   can_target_projects_workspaces = true
  #   can_target_workspace_tags      = true
  #   one_framework_per_policy_set   = true
  #   vcs_recommended_for_audit      = true
  #   sentinel_always_requires_paid  = false
  # }
  policy_set_judgements = {
    can_apply_globally             = false
    can_target_projects_workspaces = false
    can_target_workspace_tags      = false
    one_framework_per_policy_set   = false
    vcs_recommended_for_audit      = false
    sentinel_always_requires_paid  = true
  }

  # TODO 4：根据运行阶段和治理边界判断处理方式。
  # 答案级 Hint：完整答案如下：
  # governance_scenarios = {
  #   plan_failed_before_policy       = "policy_check_does_not_run"
  #   missing_required_resource_tags  = "sentinel_pre_apply_policy"
  #   manual_cloud_console_resource   = "cloud_side_compliance_control"
  #   advisory_policy_failed          = "run_continues_with_warning"
  #   hard_mandatory_policy_failed    = "run_cannot_continue_to_apply"
  # }
  governance_scenarios = {
    plan_failed_before_policy      = "run_policy_against_failed_plan"
    missing_required_resource_tags = "terraform_fmt"
    manual_cloud_console_resource  = "sentinel_automatically_deletes_it"
    advisory_policy_failed         = "run_is_permanently_blocked"
    hard_mandatory_policy_failed   = "let_workspace_admin_override"
  }
}

output "policy_model" {
  description = "Responsibilities of Sentinel, a policy, and a policy set."
  value       = local.policy_model
}

output "enforcement_choices" {
  description = "Behavior of Sentinel advisory, soft-mandatory, and hard-mandatory levels."
  value       = local.enforcement_choices
}

output "policy_set_judgements" {
  description = "Policy Set scope, framework, delivery, and availability judgements."
  value       = local.policy_set_judgements
}

output "governance_scenarios" {
  description = "Correct controls for run-stage and governance-boundary scenarios."
  value       = local.governance_scenarios
}
