run "csv_json_rule_mapping_is_correct" {
  command = plan

  assert {
    condition     = length(output.raw_rules) == 3
    error_message = "raw_rules must decode all three rows from data/sg-71.csv."
  }

  assert {
    condition = output.direct_ingress_rules == {
      https_app = {
        direction  = "ingress"
        protocol   = "tcp"
        cidr_alias = "app-1"
        cidr_ipv4  = "10.70.0.0/16"
        from_port  = 443
        to_port    = 443
      }
      http_database = {
        direction  = "ingress"
        protocol   = "tcp"
        cidr_alias = "app-2"
        cidr_ipv4  = "172.16.0.0/16"
        from_port  = 80
        to_port    = 80
      }
      metrics_ops = {
        direction  = "ingress"
        protocol   = "tcp"
        cidr_alias = "ops"
        cidr_ipv4  = "192.168.10.0/24"
        from_port  = 9090
        to_port    = 9090
      }
    }
    error_message = "direct_ingress_rules must resolve cidr_ipv4 directly from app.json using rule.cidr_alias."
  }

  assert {
    condition = output.mapped_ingress_rules == {
      https_app = {
        direction  = "ingress"
        protocol   = "tcp"
        cidr_alias = "app-1"
        cidr_ipv4  = "10.70.0.0/16"
        from_port  = 443
        to_port    = 443
      }
      http_database = {
        direction  = "ingress"
        protocol   = "tcp"
        cidr_alias = "app-2"
        cidr_ipv4  = "172.16.0.0/16"
        from_port  = 80
        to_port    = 80
      }
      metrics_ops = {
        direction  = "ingress"
        protocol   = "tcp"
        cidr_alias = "ops"
        cidr_ipv4  = "192.168.10.0/24"
        from_port  = 9090
        to_port    = 9090
      }
    }
    error_message = "mapped_ingress_rules must resolve cidr_ipv4 from app-v2.json through name_mapping."
  }

  assert {
    condition     = join(",", output.rule_labels) == "http_database:172.16.0.0/16:80,https_app:10.70.0.0/16:443,metrics_ops:192.168.10.0/24:9090"
    error_message = "rule_labels must be sorted rule_name:cidr_ipv4:port labels."
  }

  assert {
    condition = output.simulated_rule_names == [
      "http_database",
      "https_app",
      "metrics_ops"
    ]
    error_message = "terraform_data.ingress_rule must create one simulated resource per mapped rule."
  }
}
