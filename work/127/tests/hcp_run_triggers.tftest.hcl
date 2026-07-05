run "hcp_run_trigger_model_is_correct" {
  command = plan

  assert {
    condition     = output.organization == "kp-labs-org"
    error_message = "organization must be decoded from data/hcp_workspaces.json."
  }

  assert {
    condition     = keys(output.workspaces_by_name) == ["network-project", "security-project"]
    error_message = "workspaces_by_name must contain network-project and security-project keyed by name."
  }

  assert {
    condition = output.network_public_ips == [
      "8.8.8.8",
      "1.1.1.1",
      "2.2.2.2"
    ]
    error_message = "network_public_ips must read public_ips from the network workspace outputs."
  }

  assert {
    condition     = output.network_shares_state_with_security == true
    error_message = "network-project must share remote state outputs with security-project."
  }

  assert {
    condition     = output.security_has_run_trigger_from_network == true
    error_message = "security-project must have a run trigger connected to network-project."
  }

  assert {
    condition = output.run_trigger_summary == {
      source      = "network-project"
      target      = "security-project"
      auto_apply  = true
      output_name = "public_ips"
      datasource  = "tfe_outputs"
    }
    error_message = "run_trigger_summary must describe the source workspace, target workspace, auto apply behavior, output name, and preferred datasource."
  }

  assert {
    condition = output.firewall_allowlist_rules == [
      "allow:8.8.8.8",
      "allow:1.1.1.1",
      "allow:2.2.2.2"
    ]
    error_message = "firewall_allowlist_rules must derive allow:<ip> labels from network_public_ips."
  }
}
