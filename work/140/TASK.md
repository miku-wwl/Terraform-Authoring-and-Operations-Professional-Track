# 第 140 节任务：Auto Scaling Group 与 Launch Template

## 本节主旨

理解真实 ASG 的核心结构，但诚实保留 LocalStack Community 的能力边界：

```text
Launch Template ── id + version ─┐
Subnet A + Subnet B ─────────────┼─► ASG configuration model
min / desired / max ─────────────┘      （不调用 ASG API）
```

## 动手任务

1. 建模 name、min/desired/max、双 subnet、health check 和 launch template block。
2. 用 resource reference 把两个 subnet ID 和 Launch Template ID 写入模型。
3. 使用 `$Latest` 并理解它与固定版本的取舍。
4. 使用 `check` 保证 `min <= desired <= max`。
5. 运行 test、apply、验证与 destroy；apply 只创建网络和 Launch Template，不创建 ASG/实例。

答案级 Hint 位于 `main.tf` 对应 TODO 旁边。

## 接近真实 aws_autoscaling_group 的字段

| 字段 | 含义 |
|---|---|
| `vpc_zone_identifier` | ASG 使用的 subnet IDs，通常跨多个 AZ |
| `min_size` | 不低于该容量 |
| `desired_capacity` | 当前目标容量 |
| `max_size` | 不高于该容量 |
| `launch_template.id/version` | 实例启动模板及版本策略 |
| `health_check_type` | 本模型使用 EC2 健康检查 |

## `$Latest` 风险

真实 ASG 引用 `$Latest` 时，未来 scale-out 可能使用后来创建的新模板版本。生产环境常选择明确版本并通过发布流程升级；本题保留课程中的 `$Latest`，要求你能说明其影响。

## 验收标准

- fmt/validate 通过，test 为 `1 passed, 0 failed`。
- apply 创建 VPC、两个 Subnet 和 Launch Template，共 4 个资源。
- ASG 模型含两个不同 subnet ID，容量为 1/2/3。
- Launch Template ID 来自 resource reference，version 为 `$Latest`。
- check 验证容量顺序。
- 没有 `aws_autoscaling_group` 资源，也没有 EC2 instance。
- destroy 清理 4 个资源。

## 限制

- 只允许 LocalStack `test/test` 与 `localhost:4566`。
- LocalStack Community 4.2.0 无法完成 CreateAutoScalingGroup，本 Lab 只是配置模型。
- 真实扩缩容、实例健康替换、跨 AZ 平衡和费用必须在受控 AWS sandbox 验证。
