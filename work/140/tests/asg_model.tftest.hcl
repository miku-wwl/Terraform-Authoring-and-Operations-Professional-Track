run "localstack_limited_asg_model_is_understood" {
  command = apply
  assert {
    condition     = local.asg_spec.min_size == 1 && local.asg_spec.desired_capacity == 2 && local.asg_spec.max_size == 3
    error_message = "Capacity model must be 1 <= 2 <= 3."
  }
  assert {
    condition     = local.asg_spec.vpc_zone_identifier == sort([aws_subnet.a.id, aws_subnet.b.id]) && length(distinct(local.asg_spec.vpc_zone_identifier)) == 2
    error_message = "ASG model must use two distinct Terraform-created subnets."
  }
  assert {
    condition     = local.asg_spec.launch_template.id == aws_launch_template.web.id && local.asg_spec.launch_template.version == "$Latest" && local.asg_spec.health_check_type == "EC2"
    error_message = "ASG model must reference the Launch Template and EC2 health checks."
  }
}
