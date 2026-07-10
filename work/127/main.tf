# Lab 127 知识点总结：
# - 拆分 workspace 后，经常会出现“上游提供数据、下游消费数据”的依赖关系。
# - Root module outputs 是 workspace 之间共享数据的接口；没有声明为 output 的值不能直接被下游读取。
# - terraform_remote_state 或 tfe_outputs 解决“下游读取什么数据”。
# - Run Trigger 解决“上游成功 apply 后，何时让下游重新运行”。
# - 读取远端输出本身不会自动排队下游 run；数据通道和触发通道是两个独立配置。
# - Run Trigger 的 source workspace 是上游，dependent/target workspace 是被排队运行的下游。
# - Trigger 配置在下游 workspace：它声明自己监听哪些 source workspaces。
# - 只有 source workspace 成功完成 apply，才会在下游自动 queue run。
# - Speculative plan、失败的 plan 或失败的 apply 都不会满足 successful apply 触发条件。
# - 被触发的 run 默认不会因此自动 apply；是否自动 apply 由专门的 run-trigger auto-apply 设置决定。
# - 新 workspace 默认不允许其他 workspace 读取其 state，应按最小权限只分享给确实需要的下游。
# - 创建 Run Trigger 需要目标 workspace 的 admin 权限，以及读取 source workspace runs 的权限。
# - Remote state sharing 权限与 Run Trigger 是两件事：能触发不代表能读取，能读取也不代表会触发。
# - HCP Terraform 推荐用 tfe_outputs 读取 HCP workspace outputs；仍需正确的 token 与权限。
# - Run Trigger 只响应 HCP Terraform workspace 的成功 apply，不能检测绕过 Terraform 的云控制台手工变更。
# - 不应为了省掉依赖管理而把所有基础设施塞进一个巨大 workspace；这会扩大 blast radius 和 plan 噪音。
#
# 本 Lab 是概念、选择与判断题，不连接 HCP Terraform，也不模拟 workspace JSON 数据处理。
# 请完成四组判断；每个 TODO 都有可以直接替换的完整答案级 Hint。

terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：区分数据依赖与运行触发的职责和方向。
  # 答案级 Hint：完整答案如下：
  # dependency_model = {
  #   data_channel       = "workspace_outputs"
  #   timing_channel     = "run_trigger"
  #   source_workspace   = "upstream_producer"
  #   target_workspace   = "downstream_consumer"
  #   reading_auto_queues = false
  # }
  dependency_model = {
    data_channel        = "workspace_outputs"
    timing_channel      = "run_trigger"
    source_workspace    = "upstream_producer"
    target_workspace    = "downstream_consumer"
    reading_auto_queues = false
  }

  # TODO 2：判断哪些 source run 会触发下游，以及是否自动 apply。
  # 答案级 Hint：完整答案如下：
  # trigger_behaviors = {
  #   successful_apply_queues_run       = true
  #   speculative_plan_queues_run       = false
  #   failed_apply_queues_run           = false
  #   triggered_run_auto_applies_default = false
  #   dedicated_auto_apply_setting      = true
  # }
  trigger_behaviors = {
    successful_apply_queues_run        = true
    speculative_plan_queues_run        = false
    failed_apply_queues_run            = false
    triggered_run_auto_applies_default = false
    dedicated_auto_apply_setting       = true
  }

  # TODO 3：判断 state sharing、Run Trigger 和权限边界。
  # 答案级 Hint：完整答案如下：
  # access_judgements = {
  #   new_workspace_shares_state_default = false
  #   prefer_specific_consumers           = true
  #   trigger_grants_state_access          = false
  #   state_access_creates_trigger         = false
  #   create_trigger_needs_target_admin    = true
  #   create_trigger_needs_source_run_read = true
  # }
  access_judgements = {
    new_workspace_shares_state_default   = false
    prefer_specific_consumers            = true
    trigger_grants_state_access          = false
    state_access_creates_trigger         = false
    create_trigger_needs_target_admin    = true
    create_trigger_needs_source_run_read = true
  }

  # TODO 4：为常见 workspace 依赖场景选择正确做法。
  # 答案级 Hint：完整答案如下：
  # dependency_scenarios = {
  #   downstream_reads_upstream_output = "outputs_access_plus_run_trigger"
  #   upstream_apply_failed            = "do_not_queue_downstream"
  #   manual_cloud_console_change      = "run_trigger_does_not_detect_it"
  #   all_configs_in_one_workspace     = "not_required_for_dependency"
  #   evidence_of_trigger_direction    = "inbound_on_target_outbound_on_source"
  # }
  dependency_scenarios = {
    downstream_reads_upstream_output = "outputs_access_plus_run_trigger"
    upstream_apply_failed            = "do_not_queue_downstream"
    manual_cloud_console_change      = "run_trigger_does_not_detect_it"
    all_configs_in_one_workspace     = "not_required_for_dependency"
    evidence_of_trigger_direction    = "inbound_on_target_outbound_on_source"
  }
}

output "dependency_model" {
  description = "Data and timing channels in an upstream/downstream workspace dependency."
  value       = local.dependency_model
}

output "trigger_behaviors" {
  description = "Source-run conditions and auto-apply behavior for Run Triggers."
  value       = local.trigger_behaviors
}

output "access_judgements" {
  description = "Remote state sharing, Run Trigger, and permission boundaries."
  value       = local.access_judgements
}

output "dependency_scenarios" {
  description = "Correct responses to common workspace dependency scenarios."
  value       = local.dependency_scenarios
}
