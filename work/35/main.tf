# TODO：声明 data "aws_ami" "latest"，匹配 tf-lab-app-*-x86_64。

# TODO：创建 aws_instance "app"。
# 要求：
# - ami 引用 data.aws_ami.latest.id
# - instance_type 使用 t3.micro
# - tag Name=tf-lab-35-instance
# - tag Project=tf-lab-35
