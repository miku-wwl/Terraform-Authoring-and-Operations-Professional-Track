run "plugin_cache_practical_steps_are_present" {
  command = plan

  assert {
    condition     = strcontains(output.terraform_rc_content, "plugin_cache_dir = \"/workspace/.terraform-plugin-cache\"")
    error_message = "Terraform CLI 配置示例必须把 plugin_cache_dir 指向 /workspace/.terraform-plugin-cache。"
  }

  assert {
    condition     = !strcontains(output.terraform_rc_content, "plugin_cache_may_break_dependency_lock_file = true")
    error_message = "不要默认开启 plugin_cache_may_break_dependency_lock_file；它可能削弱 lock file 校验语义。"
  }

  assert {
    condition     = contains(output.implementation_steps, "保留 .terraform.lock.hcl 以稳定 provider 校验和")
    error_message = "必须强调 dependency lock file 对 plugin cache 复用的影响。"
  }

  assert {
    condition     = !strcontains(join("\n", output.implementation_steps), "TODO")
    error_message = "implementation_steps 中不能保留 TODO。"
  }
}
