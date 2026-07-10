# Lab 117 知识点总结：
# - HCP Terraform 是面向团队的 Terraform 运行与协作平台，旧资料中常称 Terraform Cloud。
# - 它不会取代 Terraform 语言，也不会让 Terraform CLI 失去价值；平台内部仍然运行 Terraform。
# - 默认 remote execution 会在 HCP Terraform 的临时运行环境中执行 plan/apply。
# - HCP Terraform workspace 类似一个独立的基础设施工作目录，保存变量、state 和 run 历史。
# - HCP Terraform workspace 与 terraform workspace CLI 命令不是同一种东西，不要混淆。
# - 配置可以来自 VCS，也可以通过 CLI/API 上传；连接 GitHub 不是使用 HCP Terraform 的硬性要求。
# - VCS-driven workflow 可以在 commit 或 pull request 发生时触发 plan。
# - 受治理的 run 可以在 plan 后执行成本估算、policy checks，再决定是否允许 apply。
# - auto-apply 关闭时，符合条件的 run 在 apply 前需要人工确认；强制策略失败会阻止 apply。
# - HCP Terraform 还提供远程 state、敏感变量、权限控制、private registry 和审计历史等能力。
#
# 本 Lab 是概念与场景判断题，不连接 HCP Terraform，也不创建任何资源。
# 你只需根据上面的知识点完成四个 locals。每个 TODO 都提供可直接替换的完整答案。

terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：判断 HCP Terraform 的定位。
  # 把下面四个 false 替换成正确答案。
  # 答案级 Hint：完整答案如下：
  # platform_facts = {
  #   replaces_terraform_language      = false
  #   terraform_cli_still_useful       = true
  #   hcp_workspace_equals_cli_workspace = false
  #   vcs_connection_is_required       = false
  # }
  platform_facts = {
    replaces_terraform_language        = false
    terraform_cli_still_useful         = false
    hcp_workspace_equals_cli_workspace = true
    vcs_connection_is_required         = true
  }

  # TODO 2：排列一个“启用了成本估算、强制策略、关闭 auto-apply”的典型 run。
  # 答案级 Hint：直接用下面这行替换空列表：
  # governed_run_phases = ["vcs_change", "plan", "cost_estimation", "policy_check", "manual_approval", "apply"]
  # 注意：这是本场景的完整流程；不同套餐、设置或 run 类型不一定包含全部阶段。
  governed_run_phases = []

  # TODO 3：为团队问题选择最合适的 HCP Terraform 能力。
  # 答案级 Hint：可以直接参考下面整段：
  # scenario_answers = {
  #   preserve_plan_apply_history = "run_history"
  #   share_and_version_state     = "remote_state"
  #   block_untagged_resources    = "policy_enforcement"
  #   share_internal_modules      = "private_registry"
  #   protect_variable_values     = "sensitive_variables"
  #   trigger_runs_from_commits   = "vcs_integration"
  # }
  scenario_answers = {}

  # TODO 4：判断失败策略与人工审批的影响。
  # 答案级 Hint：完整答案如下：
  # run_decisions = {
  #   mandatory_policy_failed          = true
  #   failed_policy_blocks_apply       = true
  #   auto_apply                       = false
  #   manual_confirmation_if_eligible  = true
  # }
  run_decisions = {
    mandatory_policy_failed         = false
    failed_policy_blocks_apply      = false
    auto_apply                      = true
    manual_confirmation_if_eligible = false
  }
}

output "platform_facts" {
  description = "Core positioning facts about HCP Terraform."
  value       = local.platform_facts
}

output "governed_run_phases" {
  description = "Example phases for a governed VCS-driven run."
  value       = local.governed_run_phases
}

output "scenario_answers" {
  description = "HCP Terraform capability selected for each team problem."
  value       = local.scenario_answers
}

output "run_decisions" {
  description = "Effects of a mandatory policy failure and disabled auto-apply."
  value       = local.run_decisions
}
