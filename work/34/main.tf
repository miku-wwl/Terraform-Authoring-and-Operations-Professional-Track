# Lab 34 知识点总结：
# - AMI ID 是 region-specific 的，真实项目里不要把某个 region 的 AMI ID 写死到代码中。
# - data "aws_ami" 用来按条件查询一个 AMI，常见用途是按名称规则选择当前 region 可用的镜像。
# - most_recent = true 表示如果匹配到多个 AMI，选择创建时间最新的那个。
# - owners 用来限制 AMI 所有者；本实验使用 ["self"]，只查询 bootstrap 注册的模拟 AMI。
# - filter name = "name" 表示按 AMI 名称过滤，values 可以使用通配符匹配名称模式。
# - 查询结果可以通过 data.aws_ami.latest.id 和 data.aws_ami.latest.name 引用。

data "aws_ami" "latest" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["tf-lab-ubuntu-*-x86_64"]
  }
}
