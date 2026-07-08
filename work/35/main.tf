# Lab 35 知识点总结：
# - 本实验把 data source 的查询结果交给 resource 使用，而不是只把查询结果输出出来。
# - data "aws_ami" 不会创建 AMI，只会查询 provider 中已经存在的 AMI。
# - 真实 AWS 里常见 AMI 可能由 Amazon、Ubuntu、Microsoft 或公司账号提前发布；
#   本实验里的 AMI 则由 scripts/bootstrap.ps1 预先注册到 LocalStack。
# - AMI ID 不应硬编码；先用 data "aws_ami" 查询当前 region 中符合条件的最新 AMI。
# - resource "aws_instance" 的 ami 可以直接引用 data.aws_ami.latest.id。
# - Terraform 会根据引用关系自动建立依赖：先读取 AMI，再用这个 AMI 创建 EC2。
# - 这种写法让同一份配置更容易适配不同 region 或不同时间更新的镜像。


data "aws_ami" "latest" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["tf-lab-app-*-x86_64"]
  }
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.latest.id
  instance_type = "t3.micro"

  tags = {
    Name    = "tf-lab-35-instance"
    Project = "tf-lab-35"
  }
}
