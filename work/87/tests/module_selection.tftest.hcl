run "module_selection_rules_are_correct" {
  command = plan

  assert {
    condition     = length(output.modules) == 6
    error_message = "modules must decode all candidates from data/module_candidates.json."
  }

  assert {
    condition = output.ec2_module_names == [
      "terraform-aws-modules/ec2-instance/aws",
      "solo-dev/ec2/aws",
      "legacy-org/ec2-instance/aws",
      "shady-lab/ec2/aws"
    ]
    error_message = "ec2_module_names must select module names where service is ec2."
  }

  assert {
    condition = output.trusted_module_names == [
      "hashicorp-partner/network/google",
      "terraform-aws-modules/ec2-instance/aws"
    ]
    error_message = "trusted_module_names must include only modules that pass all trusted rules."
  }

  assert {
    condition = output.review_required_module_names == [
      "solo-dev/ec2/aws",
      "legacy-org/ec2-instance/aws",
      "shady-lab/ec2/aws"
    ]
    error_message = "review_required_module_names must include modules with risky maintenance or source-review signals."
  }

  assert {
    condition = output.module_quality_labels == [
      "terraform-aws-modules/ec2-instance/aws:trusted",
      "hashicorp-partner/network/google:trusted",
      "solo-dev/ec2/aws:review",
      "legacy-org/ec2-instance/aws:review",
      "community/iam/aws:usable",
      "shady-lab/ec2/aws:review"
    ]
    error_message = "module_quality_labels must classify each module as trusted, review, or usable."
  }

  assert {
    condition     = output.recommended_ec2_module_name == "terraform-aws-modules/ec2-instance/aws"
    error_message = "recommended_ec2_module_name must pick the trusted EC2 module candidate."
  }
}
