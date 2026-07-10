run "localstack_launch_template_is_understood" {
  command = apply
  assert {
    condition     = output.launch_template_summary.name == "tf-pro-lab-139-web" && output.launch_template_summary.image_id == "ami-12345678" && output.launch_template_summary.instance_type == "t3.micro"
    error_message = "Launch Template core parameters are incorrect."
  }
  assert {
    condition     = output.launch_template_summary.security_group_ids == toset([aws_security_group.web.id]) && output.launch_template_summary.latest_version == 1 && output.launch_template_summary.default_version == 1
    error_message = "Security Group reference or initial versions are incorrect."
  }
  assert {
    condition     = output.launch_template_summary.launch_template_tags.Name == "tf-pro-lab-139-template" && output.launch_template_summary.future_instance_tags.Name == "tf-pro-lab-139-instance"
    error_message = "Launch Template tags and future instance tags must remain distinct."
  }
}
