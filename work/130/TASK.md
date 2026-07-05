# Terraform 实操训练 130：HCP Terraform Health Assessments 基础

## 1. 背景

本目录是 `work/130` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 HCP Terraform Health Assessments 的概念整理练习。

HCP Terraform 的 Health Assessments 可以在 workspace 里做自动健康评估，目标是判断真实基础设施和 Terraform 期望状态、以及持续健康条件是否仍然一致。这个能力在企业环境很有用，但不是免费基础层的完整可测能力，所以本节用静态文件练习核心概念。

## 2. 核心主题

- Health Assessments：workspace 级别的自动健康评估。
- Drift detection：判断真实基础设施是否仍然匹配 Terraform configuration。
- Configuration drift：常见原因是有人在云控制台手工修改资源。
- Continuous validation：资源 provision 之后，持续检查自定义条件是否仍然通过。
- Terraform `check` block：CLI 免费版本也可以表达类似健康检查逻辑，例如 HTTP status code 是否为 `200`。
- 版本层级限制：Health Assessments 不是 Essentials/free 基础能力，通常需要 Standard / Premium / Enterprise 等付费层级。
- 替代思路：自建 `terraform plan -detailed-exitcode` drift check，配合 `terraform test`、cron 和 Slack 告警。

## 3. 任务目标

请完成下面十个 TODO：

1. 在 `hcp/health_assessments.md` 的 Feature purpose 中写入：

   ```text
   HCP Terraform health assessments evaluate whether real infrastructure matches Terraform configuration.
   ```

2. 在 Drift detection 中写入：

   ```text
   Drift detection determines whether real infrastructure matches Terraform configuration.
   ```

3. 在 Drift detection 中补充常见原因：

   ```text
   Manual changes can cause configuration drift.
   ```

4. 在 Continuous validation 中写入：

   ```text
   Continuous validation checks whether custom conditions continue to pass after Terraform provisions the resource.
   ```

5. 在 Tier availability 中写入：

   ```text
   Health assessments are available in Standard and Premium tiers, and are not available in Essentials.
   ```

6. 在 `examples/continuous_validation_check.tf` 中补全 HTTP data source：

   ```hcl
   data "http" "website" {
     url = "https://example.com"
   }
   ```

7. 在同一个文件中补全 check block 名称：

   ```hcl
   check "website_health" {
   ```

8. 在 assert condition 中检查 HTTP 状态码：

   ```hcl
   condition = data.http.website.status_code == 200
   ```

9. 在 error message 中写入：

   ```hcl
   error_message = "Website returned an unhealthy status code."
   ```

10. 在 `commands/health_assessment_alternatives.sh` 中补全替代自动化命令和说明：

    ```sh
    terraform plan -detailed-exitcode
    terraform test
    # Run this from cron every 3 minutes and send failed results to Slack.
    ```

完成后运行 `README.md` 中的命令。

## 4. 验收方式

基础检查：

```sh
terraform init -input=false
terraform fmt
terraform validate
terraform test
```

可选观察输出：

```sh
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

## 5. 预期结果

- `terraform test` 返回 `1 passed, 0 failed`。
- `output.health_assessments_summary_is_complete` 为 `true`。
- `output.drift_detection_is_described` 为 `true`。
- `output.continuous_validation_is_described` 为 `true`。
- `output.tier_limitation_is_documented` 为 `true`。
- `output.check_block_example_is_present` 为 `true`。
- `output.alternative_workflow_is_documented` 为 `true`。

## 6. 约束

- 不要修改 `tests/` 下的测试文件。
- 不要把 `examples/continuous_validation_check.tf` 移到根目录；否则 Terraform 会尝试加载 HTTP provider。
- 本 lab 不要求真实连接 HCP Terraform，也不要求启用付费功能。
- `check` block 示例必须保留为静态示例文件。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
