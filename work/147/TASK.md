# Terraform 实操训练 147：Terraform Professional Exam 实战策略

## 1. 背景

本目录是 `work/147` 上机做题环境。这里不是参考答案目录，你需要在当前目录内完成 Terraform Professional lab-based exam tips 的静态整理练习。

这一节不是新 Terraform 语法点，而是考试操作方法论。视频强调：考试场景通常有多个 scenario，每个 scenario 又有多个 task。你需要先保护原始代码，再快速识别容易拿分的题，熟悉 Terraform 文档入口，并在每个 task 完成后用 validation command 验证。

## 2. 核心主题

- Base scenario backup：开始修改前，先把 Desktop 下的 `scenarios` 目录复制一份，避免误改后无法恢复。
- Exam-only provider block：考试场景中可以把右侧面板提供的 AWS access key / secret key 明确写到 provider block，减少凭据混乱。
- Scenario triage：先读 scenario 和 task 数量，优先完成简单、耗时短的 scenario。
- Task-level triage：如果 task 之间不是严格链式依赖，先完成独立且容易的 task，把卡住的 task 留到最后。
- Documentation familiarity：熟悉 Terraform docs 的 Configuration Language、Terraform CLI、HCP Terraform 等入口。
- Remote state navigation：有些示例不在第一个页面；AWS S3 backend 的页面里可能有 `terraform_remote_state` data source 示例。
- Validation mindset：考试只看你是否完成并通过 validation command；但这种 bad code 思路不能带到真实生产工程里。
- Anxiety control：考试有两次机会，但仍然应该按第一次就通过来准备。

## 3. 任务目标

请完成下面十二个 TODO：

1. 在 `exam/exam_strategy.md` 的 Backup base scenarios 中写入：

   ```text
   Copy the scenarios folder before modifying any lab.
   ```

2. 在同一段中写入：

   ```text
   Desktop/scenarios
   ```

3. 在 Provider block strategy 中写入：

   ```text
   In the exam, explicitly add the AWS provider block with the scenario access key and secret key.
   ```

4. 在 Scenario triage 中写入：

   ```text
   Choose easy scenarios first.
   ```

5. 在 Task-level triage 中写入：

   ```text
   Complete independent tasks before returning to blocked tasks.
   ```

6. 在 Documentation familiarity 中写入：

   ```text
   Be familiar with Terraform documentation before the exam.
   ```

7. 在 Validation mindset 中写入：

   ```text
   Bad code is acceptable only in the exam when the validation command passes.
   ```

8. 在 Two-attempt mindset 中写入：

   ```text
   There are two attempts, but prepare to pass on the first attempt.
   ```

9. 在 `exam/provider_template.tf` 中补全考试用 AWS provider 模板，至少包含：

   ```hcl
   provider "aws" {
     region     = "us-east-1"
     access_key = "EXAM_ACCESS_KEY"
     secret_key = "EXAM_SECRET_KEY"
   }
   ```

10. 在 `exam/docs_navigation.md` 中写入这些文档入口和关键词：

    ```text
    Configuration Language
    Terraform CLI
    HCP Terraform
    terraform_remote_state
    S3 backend
    ```

11. 在同一文件中写入：

    ```text
    S3 backend documentation can contain remote state data source examples.
    ```

12. 在 `exam/workflow_checklist.sh` 中补全备份、检查和验证命令/说明，至少包含：

    ```sh
    cp -r ~/Desktop/scenarios ~/Desktop/scenarios-backup
    terraform fmt
    terraform validate
    terraform plan
    # Run the scenario validation command after each completed task.
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
- `output.backup_strategy_is_documented` 为 `true`。
- `output.exam_provider_strategy_is_documented` 为 `true`。
- `output.scenario_triage_is_documented` 为 `true`。
- `output.task_level_triage_is_documented` 为 `true`。
- `output.docs_navigation_is_documented` 为 `true`。
- `output.validation_mindset_is_documented` 为 `true`。
- `output.two_attempt_mindset_is_documented` 为 `true`。
- `output.workflow_checklist_is_documented` 为 `true`。

## 6. 约束

- 不要修改 `tests/` 下的测试文件。
- 不要把 `exam/provider_template.tf` 移到根目录；否则 Terraform 可能会尝试加载 AWS provider。
- 不要在真实项目里硬编码云凭据。本练习里的 provider block 是考试环境策略说明，不是生产最佳实践。
- 本 lab 不要求真实连接 AWS、HCP Terraform 或 Terraform Registry。
- 最终提交应保留 starter TODO 状态，不要把答案直接提交进去。
