# 第 133 节任务：aws_subnets 与 aws_subnet

## 本节主旨

理解 AWS Provider 中“查询集合”和“查询单个对象”的职责差异：

| Data source | 查询结果 | 典型用途 |
|---|---|---|
| `aws_subnets` | 多个 subnet IDs | 找出某个 VPC、标签或条件下的 subnet 集合 |
| `aws_subnet` | 一个 subnet 的详细属性 | 获取 CIDR、AZ、VPC ID 等属性供其他配置使用 |

## 执行链

```text
aws_vpc.lab
  ├─ aws_subnet.a
  └─ aws_subnet.b
         │
         ├─ aws_subnets.lab ──► ids
         └─ aws_subnet.first ─► cidr_block / AZ / vpc_id
```

## 动手任务

1. 创建 `aws_subnet.a` 和 `aws_subnet.b`。
2. 用 `aws_subnets` 的 `vpc-id` filter 查询两个 subnet IDs。
3. 用 `aws_subnet` 按 `aws_subnet.a.id` 查询详细属性。
4. 输出排序后的 IDs、数量和第一个 subnet 的详情。

所有语法的完整答案都放在 `main.tf` 对应 TODO 旁边。

## Filter 的含义

```hcl
filter {
  name   = "vpc-id"
  values = [aws_vpc.lab.id]
}
```

- `name` 使用 EC2 DescribeSubnets API 支持的过滤字段。
- `values` 是该字段可接受的值集合。
- 多个 filter block 共同缩小查询范围。
- 也可以使用 `tags = { ... }` 或 `name = "tag:Name"` 查询标签。

## 依赖关系

集合查询只引用 `aws_vpc.lab.id`，Terraform 只能自动推导它依赖 VPC，无法从 filter 推断它还应等待两个 subnet。因此本题需要：

```hcl
depends_on = [aws_subnet.a, aws_subnet.b]
```

单对象查询写成：

```hcl
id = aws_subnet.a.id
```

这个引用已经形成隐式依赖，不需要额外 `depends_on`。

## 不要依赖集合顺序

`aws_subnets.ids` 表示匹配结果集合。即使当前 Provider 类型表现为 list，也不应把 API 返回顺序当成业务保证。

本题只在 output 使用：

```hcl
sort(data.aws_subnets.lab.ids)
```

如果业务要选择某个 subnet，应使用唯一 ID、精确标签、CIDR、AZ 等明确条件，而不是 `ids[0]`。

## LocalStack 边界

本实验可以验证：

- VPC/subnet resource 生命周期；
- EC2 DescribeSubnets 查询；
- plural/singular data source；
- Terraform 显式和隐式依赖；
- outputs 与 state。

它不能代替真实 AWS 中的路由表、NACL、Security Group、跨 AZ 可用性或网络连通性验证。

## 验收标准

- `terraform fmt -check` 和 `terraform validate` 通过。
- `terraform test` 返回 `1 passed, 0 failed`。
- `subnet_count` 等于 `2`。
- `subnet_ids` 同时包含两个 Terraform 创建的 subnet ID。
- `first_subnet.cidr_block` 是 `10.132.1.0/24`。
- `first_subnet.availability_zone` 是 `us-east-1a`。
- `first_subnet.vpc_id` 等于 `aws_vpc.lab.id`。
- 手动 apply 后 verify 通过，最终 destroy 清理三个 managed resources。

## 限制

- 只允许连接 `http://localhost:4566`。
- 只使用 `test/test` LocalStack 测试 credentials。
- 不要修改 `practice/labs/133/`。
- 不要使用 `subnet_ids[0]` 代替精确查询。
- 验收完成后必须 destroy。
