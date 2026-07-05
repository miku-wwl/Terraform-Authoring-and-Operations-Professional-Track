run "module_reference_metadata_is_processed_correctly" {
  command = plan

  assert {
    condition     = length(output.modules) == 4
    error_message = "modules must decode all module metadata objects from data/module-catalog.json."
  }

  assert {
    condition     = output.direct_apply_module_names == ["ec2_instance"]
    error_message = "direct_apply_module_names must only include modules marked as directly plannable without extra required inputs."
  }

  assert {
    condition = output.modules_requiring_inputs == {
      eks_cluster = ["cluster_name", "subnet_ids"]
      iam_user    = ["name"]
    }
    error_message = "modules_requiring_inputs must map only modules with required_inputs to their required input names."
  }

  assert {
    condition = output.missing_inputs_by_module == {
      eks_cluster = ["cluster_name"]
      iam_user    = ["name"]
    }
    error_message = "missing_inputs_by_module must compare required_inputs with provided_inputs and keep only modules with missing values."
  }

  assert {
    condition = output.submodule_sources == [
      "terraform-aws-modules/iam/aws//modules/iam-user"
    ]
    error_message = "submodule_sources must include only modules whose module_path is not root."
  }

  assert {
    condition     = output.container_module_names == ["iam_root"]
    error_message = "container_module_names must identify root modules that expose submodule folders."
  }

  assert {
    condition = output.plan_adds_by_module == {
      ec2_instance = 1
      eks_cluster  = 24
      iam_root     = 0
      iam_user     = 3
    }
    error_message = "plan_adds_by_module must map every module name to expected_plan_adds."
  }
}
