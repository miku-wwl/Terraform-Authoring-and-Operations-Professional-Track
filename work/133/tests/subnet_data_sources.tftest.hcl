run "localstack_subnet_data_sources_are_understood" {
  command = apply

  assert {
    condition     = output.subnet_count == 2
    error_message = "aws_subnets must return exactly the two subnets created in aws_vpc.lab."
  }

  assert {
    condition = (
      contains(output.subnet_ids, aws_subnet.a.id) &&
      contains(output.subnet_ids, aws_subnet.b.id)
    )
    error_message = "The plural aws_subnets result must contain both Terraform-created subnet IDs."
  }

  assert {
    condition = output.first_subnet == {
      id                = aws_subnet.a.id
      cidr_block        = "10.132.1.0/24"
      availability_zone = "us-east-1a"
      vpc_id            = aws_vpc.lab.id
    }
    error_message = "The singular aws_subnet result must expose subnet A's ID, CIDR, AZ, and VPC ID."
  }
}
