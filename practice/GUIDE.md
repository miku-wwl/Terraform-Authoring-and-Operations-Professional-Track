# Terraform 练习步骤指南

## 环境架构

```
你的 VS Code (Windows)                 Docker 容器 (Linux)
┌─────────────────────────┐            ┌─────────────────────────┐
│  编辑 .tf 文件           │            │  hashicorp/terraform    │
│  practice/main.tf       │── 卷映射 ──│  /workspace/practice/   │
│  practice/*.tf          │            │                         │
│                         │            │  $ terraform init       │
│  生成的 output/ 文件     │←── 卷映射 ──│  $ terraform plan       │
│  在 VS Code 中可见       │            │  $ terraform apply      │
└─────────────────────────┘            └─────────────────────────┘
```

## 1. 启动容器（已帮你启动好了）

```bash
docker run -it --rm --name tf-practice \
  -v "D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track:/workspace" \
  -w /workspace \
  --entrypoint sh \
  hashicorp/terraform:1.11
```

> 当前容器 `tf-practice` 已在终端中运行，**不要关掉那个终端**。

## 2. 基础工作流（在容器终端中执行）

```bash
# 进入练习目录
cd /workspace/practice

# ① 初始化（下载 provider）
terraform init

# ② 查看计划（不执行，只看变更）
terraform plan

# ③ 保存计划到文件（CI/CD 自动化必备）
terraform plan -out=tfplan

# ④ 应用变更
terraform apply -auto-approve

# ⑤ 查看输出
terraform output

# ⑥ 销毁资源
terraform destroy -auto-approve
```

## 3. 练习任务清单

### 练习 A：感受 Terraform 核心流程
1. 在 VS Code 中打开 `practice/main.tf`
2. 进入容器，执行 `terraform init → plan → apply`
3. 检查 `practice/output/` 目录，确认文件生成
4. 执行 `terraform destroy` 清理

### 练习 B：修改代码看变更
1. 在 `main.tf` 中把 `users` 列表加一个 `"dave"`
2. 回容器执行 `terraform plan`，观察 Terraform 只新增 1 个文件
3. `terraform apply -auto-approve`

### 练习 C：练习自动化参数
1. 尝试 `terraform plan -no-color`（去掉 ANSI 颜色码）
2. 尝试 `terraform plan -input=false`（禁止交互输入）
3. 尝试 `terraform plan -out=tfplan` 然后 `terraform apply tfplan`

### 练习 D：练习 state 命令
```bash
terraform state list          # 列出所有资源
terraform state show local_file.hello   # 查看单个资源详情
```

### 练习 E：练习变量
```bash
# 用 -var 覆盖变量
terraform plan -var 'users=["x","y","z"]'

# 用环境变量
TF_VAR_greeting="Hello CI" terraform plan
```

### 练习 F：创建你自己的 .tf 文件
1. 在 VS Code 中新建 `practice/my-practice.tf`
2. 写一个 `local_file` 资源，生成任意内容
3. 进容器执行 `init → plan → apply`

## 4. 常用命令速查

| 命令 | 用途 |
|------|------|
| `terraform init` | 初始化工作目录 |
| `terraform plan` | 预览变更 |
| `terraform plan -out=tfplan` | 保存执行计划 |
| `terraform apply tfplan` | 应用已保存的计划 |
| `terraform apply -auto-approve` | 跳过确认直接应用 |
| `terraform destroy` | 销毁所有资源 |
| `terraform output` | 查看输出值 |
| `terraform state list` | 列出状态中所有资源 |
| `terraform fmt` | 格式化代码 |
| `terraform validate` | 验证语法 |
| `terraform console` | 交互式表达式测试 |

## 5. 容器管理

```bash
# 如果容器关了，在 PowerShell 中重新启动
docker run -it --rm --name tf-practice `
  -v "D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track:/workspace" `
  -w /workspace `
  --entrypoint sh `
  hashicorp/terraform:1.11
```

## 6. 说明

- **官方镜像优势**：仅 ~45MB，HashiCorp 官方构建，版本号即 tag
- **卷映射**：你在 VS Code 写的 `.tf` 文件，容器内立即可见；容器生成的文件（如 `output/`、`terraform.tfstate`），在 Windows 资源管理器也能看到
- **无需 AWS**：所有基础语法练习（变量、函数、循环、条件、模块、状态命令等）都可用 `local` provider 完成
