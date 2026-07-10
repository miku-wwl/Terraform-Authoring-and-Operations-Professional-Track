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
# 四个 locals 练习均已完成，下面保留参考答案和相关知识点供复习。

terraform {
  required_version = ">= 1.5.0"
}

locals {
  # 已完成 1：判断 HCP Terraform 的定位。
  # 参考答案如下：
  # platform_facts = {
  #   replaces_terraform_language      = false
  #   terraform_cli_still_useful       = true
  #
  #   Terraform CLI Workspace 知识点：
  #   - CLI workspace 不切换代码，只切换当前配置使用的 state。
  #   - 同一份代码可以通过不同 state 和变量分别管理 dev、test、prod 等多套资源。
  #   - workspace 不会自动加载同名 tfvars；仍需显式使用 -var-file，或在代码中读取 terraform.workspace。
  #   - 常用命令：terraform workspace list / show / new <name> / select <name> / delete <name>。
  #   - terraform workspace select dev 之后，plan/apply 只会读取 dev workspace 对应的 state。
  #   - CLI workspace 主要隔离 state；HCP workspace 还管理变量、远程运行、权限、审批和 run 历史。
  #
  #   hcp_workspace_equals_cli_workspace = false
  #   vcs_connection_is_required       = false
  # }
  platform_facts = {
    replaces_terraform_language        = false
    terraform_cli_still_useful         = true
    hcp_workspace_equals_cli_workspace = false
    vcs_connection_is_required         = false
  }

  # 已完成 2：排列一个“启用了成本估算、强制策略、关闭 auto-apply”的典型 run。
  # 参考答案如下：
  # governed_run_phases = ["vcs_change", "plan", "cost_estimation", "policy_check", "manual_approval", "apply"]
  # 注意：这是本场景的完整流程；不同套餐、设置或 run 类型不一定包含全部阶段。
  governed_run_phases = ["vcs_change", "plan", "cost_estimation", "policy_check", "manual_approval", "apply"]

  # 已完成 3：为团队问题选择最合适的 HCP Terraform 能力。
  # 参考答案如下：
  # scenario_answers = {
  #   preserve_plan_apply_history = "run_history"
  #   share_and_version_state     = "remote_state"
  #   block_untagged_resources    = "policy_enforcement"
  #   share_internal_modules      = "private_registry"
  #   protect_variable_values     = "sensitive_variables"
  #   trigger_runs_from_commits   = "vcs_integration"
  # }
  scenario_answers = {
    preserve_plan_apply_history = "run_history"
    share_and_version_state     = "remote_state"
    block_untagged_resources    = "policy_enforcement"
    share_internal_modules      = "private_registry"
    protect_variable_values     = "sensitive_variables"
    trigger_runs_from_commits   = "vcs_integration"
  }

  # 已完成 4：判断失败策略与人工审批的影响。
  # 参考答案如下：
  # run_decisions = {
  #   mandatory_policy_failed          = true
  #   failed_policy_blocks_apply       = true
  #   auto_apply                       = false
  #   manual_confirmation_if_eligible  = true
  # }
  run_decisions = {
    mandatory_policy_failed         = true
    failed_policy_blocks_apply      = true
    auto_apply                      = false
    manual_confirmation_if_eligible = true
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
