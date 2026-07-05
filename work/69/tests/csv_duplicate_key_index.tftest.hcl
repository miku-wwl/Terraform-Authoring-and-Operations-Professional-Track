run "csv_duplicate_names_use_index_keys" {
  command = plan

  assert {
    condition     = length(output.rules) == 4
    error_message = "rules must decode all four rows from data/sg-02.csv."
  }

  assert {
    condition     = length(output.ingress_rules) == 2
    error_message = "ingress_rules must keep only rows where direction is ingress."
  }

  assert {
    condition     = length(output.egress_rules) == 2
    error_message = "egress_rules must keep only rows where direction is egress."
  }

  assert {
    condition     = keys(output.ingress_rules_by_index) == ["0", "1"]
    error_message = "ingress_rules_by_index must be keyed by index, not by duplicate rule name."
  }

  assert {
    condition     = keys(output.egress_rules_by_index) == ["0", "1"]
    error_message = "egress_rules_by_index must be keyed by index, not by duplicate rule name."
  }

  assert {
    condition = output.ingress_rule_inputs == {
      "0" = {
        security_group = "use-case-02-sg"
        name           = "web"
        direction      = "ingress"
        from_port      = "80"
        to_port        = "80"
        protocol       = "tcp"
        cidr_block     = "10.0.0.0/24"
        description    = "HTTP inbound from app subnet"
      }
      "1" = {
        security_group = "use-case-02-sg"
        name           = "web"
        direction      = "ingress"
        from_port      = "443"
        to_port        = "443"
        protocol       = "tcp"
        cidr_block     = "10.0.1.0/24"
        description    = "HTTPS inbound from app subnet"
      }
    }
    error_message = "ingress_rule terraform_data resources must be created from index-keyed ingress rules."
  }

  assert {
    condition = output.egress_rule_inputs == {
      "0" = {
        security_group = "use-case-02-sg"
        name           = "web"
        direction      = "egress"
        from_port      = "443"
        to_port        = "443"
        protocol       = "tcp"
        cidr_block     = "0.0.0.0/0"
        description    = "HTTPS outbound to internet"
      }
      "1" = {
        security_group = "use-case-02-sg"
        name           = "web"
        direction      = "egress"
        from_port      = "53"
        to_port        = "53"
        protocol       = "udp"
        cidr_block     = "0.0.0.0/0"
        description    = "DNS outbound to resolver"
      }
    }
    error_message = "egress_rule terraform_data resources must be created from index-keyed egress rules."
  }
}
