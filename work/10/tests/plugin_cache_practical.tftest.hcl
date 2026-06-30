run "plugin_cache_practical_steps_are_present" {
  command = plan

  assert {
    condition     = contains(output.implementation_steps, "保留 .terraform.lock.hcl 以稳定 provider 校验和")
    error_message = "必须强调 dependency lock file 对 plugin cache 复用的影响。"
  }
}

