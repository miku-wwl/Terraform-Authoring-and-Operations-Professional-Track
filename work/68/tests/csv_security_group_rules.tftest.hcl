run "csv_security_group_rules_are_correct" {
  command = plan

  assert {
    condition     = length(output.csv_rules) == 4
    error_message = "csv_rules must decode all four rules from data/sg-01.csv."
  }

  assert {
    condition     = output.inbound_rule_names == ["rule-01", "rule-02"]
    error_message = "inbound_rule_names must select only rules where direction is in."
  }

  assert {
    condition     = output.outbound_rule_names == ["rule-03", "rule-04"]
    error_message = "outbound_rule_names must select only rules where direction is out."
  }

  assert {
    condition = output.inbound_rules_by_name == {
      rule-01 = {
        name        = "rule-01"
        direction   = "in"
        cidr_block  = "10.0.1.0/24"
        from_port   = "80"
        to_port     = "80"
        protocol    = "tcp"
        description = "allow_http_from_app_subnet"
      }
      rule-02 = {
        name        = "rule-02"
        direction   = "in"
        cidr_block  = "10.0.2.0/24"
        from_port   = "443"
        to_port     = "443"
        protocol    = "tcp"
        description = "allow_https_from_web_subnet"
      }
    }
    error_message = "inbound_rules_by_name must map inbound rules by unique name."
  }

  assert {
    condition = output.outbound_rules_by_name == {
      rule-03 = {
        name        = "rule-03"
        direction   = "out"
        cidr_block  = "0.0.0.0/0"
        from_port   = "8443"
        to_port     = "8443"
        protocol    = "tcp"
        description = "allow_app_to_external_api"
      }
      rule-04 = {
        name        = "rule-04"
        direction   = "out"
        cidr_block  = "10.10.0.0/16"
        from_port   = "3306"
        to_port     = "3306"
        protocol    = "tcp"
        description = "allow_app_to_database"
      }
    }
    error_message = "outbound_rules_by_name must map outbound rules by unique name."
  }

  assert {
    condition = output.ingress_rule_models == {
      rule-01 = {
        name                = "rule-01"
        direction           = "in"
        security_group_name = "use-case-01-sg"
        cidr_ipv4           = "10.0.1.0/24"
        from_port           = 80
        to_port             = 80
        ip_protocol         = "tcp"
        description         = "allow_http_from_app_subnet"
      }
      rule-02 = {
        name                = "rule-02"
        direction           = "in"
        security_group_name = "use-case-01-sg"
        cidr_ipv4           = "10.0.2.0/24"
        from_port           = 443
        to_port             = 443
        ip_protocol         = "tcp"
        description         = "allow_https_from_web_subnet"
      }
    }
    error_message = "ingress_rule_models must be created with for_each from inbound rules and numeric ports."
  }

  assert {
    condition = output.egress_rule_models == {
      rule-03 = {
        name                = "rule-03"
        direction           = "out"
        security_group_name = "use-case-01-sg"
        cidr_ipv4           = "0.0.0.0/0"
        from_port           = 8443
        to_port             = 8443
        ip_protocol         = "tcp"
        description         = "allow_app_to_external_api"
      }
      rule-04 = {
        name                = "rule-04"
        direction           = "out"
        security_group_name = "use-case-01-sg"
        cidr_ipv4           = "10.10.0.0/16"
        from_port           = 3306
        to_port             = 3306
        ip_protocol         = "tcp"
        description         = "allow_app_to_database"
      }
    }
    error_message = "egress_rule_models must be created with for_each from outbound rules and numeric ports."
  }
}
