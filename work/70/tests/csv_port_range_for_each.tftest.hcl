run "csv_port_ranges_are_processed_correctly" {
  command = plan

  assert {
    condition     = length(output.csv_data) == 3
    error_message = "csv_data must decode all three rows from data/sg_03.csv."
  }

  assert {
    condition = output.processed_rules == [
      {
        name       = "web"
        direction  = "in"
        protocol   = "tcp"
        cidr_block = "0.0.0.0/0"
        from_port  = 80
        to_port    = 100
      },
      {
        name       = "web"
        direction  = "in"
        protocol   = "tcp"
        cidr_block = "10.0.0.0/16"
        from_port  = 443
        to_port    = 445
      },
      {
        name       = "web"
        direction  = "in"
        protocol   = "tcp"
        cidr_block = "192.168.10.0/24"
        from_port  = 8443
        to_port    = 8443
      }
    ]
    error_message = "processed_rules must split ranged ports and reuse single ports for both from_port and to_port."
  }

  assert {
    condition     = output.ingress_rule_keys == ["web-0", "web-1", "web-2"]
    error_message = "ingress_rules_by_key must use unique keys that combine rule name and index."
  }

  assert {
    condition = output.ingress_rules_by_key == {
      "web-0" = {
        name       = "web"
        direction  = "in"
        protocol   = "tcp"
        cidr_block = "0.0.0.0/0"
        from_port  = 80
        to_port    = 100
      }
      "web-1" = {
        name       = "web"
        direction  = "in"
        protocol   = "tcp"
        cidr_block = "10.0.0.0/16"
        from_port  = 443
        to_port    = 445
      }
      "web-2" = {
        name       = "web"
        direction  = "in"
        protocol   = "tcp"
        cidr_block = "192.168.10.0/24"
        from_port  = 8443
        to_port    = 8443
      }
    }
    error_message = "ingress_rules_by_key must preserve processed rule values under unique keys."
  }

  assert {
    condition = output.ingress_rule_inputs == {
      "web-0" = {
        name       = "web"
        direction  = "in"
        protocol   = "tcp"
        cidr_block = "0.0.0.0/0"
        from_port  = 80
        to_port    = 100
      }
      "web-1" = {
        name       = "web"
        direction  = "in"
        protocol   = "tcp"
        cidr_block = "10.0.0.0/16"
        from_port  = 443
        to_port    = 445
      }
      "web-2" = {
        name       = "web"
        direction  = "in"
        protocol   = "tcp"
        cidr_block = "192.168.10.0/24"
        from_port  = 8443
        to_port    = 8443
      }
    }
    error_message = "terraform_data.ingress_rule must receive all processed rule values through for_each."
  }
}
