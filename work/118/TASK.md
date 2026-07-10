# Terraform 实操训练 118：HCP Terraform 定价判断

## 本节主旨

本节不是让你背一张可能很快过期的美元价格表，而是建立三个判断框架：

```text
使用哪种交付模式？
→ HCP Terraform 托管 SaaS / Terraform Enterprise 自托管

主要按什么计费？
→ Managed Resources / Resources Under Management

哪些信息会变化？
→ 单价、免费额度、套餐名称和精确 feature matrix
```

## 阶段 1：托管与自托管

完成 `main.tf` 的 TODO 1。

- HCP Terraform：HashiCorp/IBM 运营的托管 SaaS。
- Terraform Enterprise：组织自行部署和运营。
- Air-gapped、强隔离和完全私有部署需求通常指向 Terraform Enterprise。

Terraform Enterprise 不是简单的“第四个云端套餐”，部署和运营责任不同。

## 阶段 2：Managed Resource 计费

完成 TODO 2。

当前官方 PAYG 计费重点是每个计费小时中的 managed resource 峰值。Managed resource 是 HCP Terraform 管理的 state 中 `mode = "managed"` 的资源。

需要避免的误解：

- 不是每运行一次 `plan` 就按一份完整基础设施额外计数。
- 修改同一个资源很多次，不代表它自动变成很多个 managed resources。
- 当前 PAYG 规则中，部分小时按完整小时计。

具体计价公式和单价可能变化，预算时必须使用当前官方页面和实际资源规模。

## 阶段 3：场景选择

完成 TODO 3：

| 场景 | 正确方向 |
|---|---|
| 小团队学习体验 | 查询当前 Free/trial 条件 |
| 需要审计、漂移检测、持续验证 | 查询当前 Standard 或更高层级 feature matrix |
| 需要 air-gapped 安装 | Terraform Enterprise |
| 需要精确月度预算 | 当前官方单价 + 实际 managed resource 使用量 |

当前官方文档显示付费 edition 具有递增包含关系，但功能打包仍可能变化。

## 阶段 4：考试记忆策略

完成 TODO 4。

应该理解和记忆：

- Managed resource 的计费思路；
- SaaS 与 self-hosted 的区别；
- 治理、审计、漂移检测属于平台高级能力。

不应长期死记：

- 某个固定美元价格；
- 某个时间点的免费额度；
- 每个套餐完整、逐项的 feature matrix。

## 最终验收

```powershell
terraform fmt
terraform validate
terraform test
```

预期：

```text
Success! 1 passed, 0 failed.
```

## 你现在应该能回答

1. HCP Terraform 与 Terraform Enterprise 的交付模式有什么区别？
2. HCP Terraform PAYG 的主要使用量单位是什么？
3. 反复修改同一个资源是否等于不断增加 managed resource 数量？
4. Air-gapped 环境通常选择哪个方向？
5. 为什么不应该死记课程截图里的美元价格？

## 官方核对入口

- [HCP Terraform plans and features](https://developer.hashicorp.com/terraform/cloud-docs/overview)
- [Estimate HCP Terraform cost](https://developer.hashicorp.com/terraform/cloud-docs/overview/estimate-hcp-terraform-cost)
- [HashiCorp product pricing](https://www.hashicorp.com/en/pricing)
