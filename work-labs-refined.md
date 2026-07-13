# Terraform Work Labs 精炼总结

本文按 `work` 目录中的实际编号汇总，共 167 个 Lab。编号从 Lab 5 开始，包含 Lab 134.5；仓库中没有 Lab 151。示例只保留理解知识点所需的最小配置或命令，真实运行仍应以各 Lab 的 `TASK.md`、`README.md` 和验收脚本为准。

## 核心知识（Lab 5：Terraform 自动化环境 CLI 工作流）

- 自动化任务必须禁用交互输入，避免 CI/CD runner 等待人工响应。
- `plan -out` 保存经过审查的执行计划；`apply` 应直接使用该 plan 文件。
- `-no-color` 去掉 ANSI 控制符，使日志和扫描工具更容易处理。

## 最小代码（Lab 5）

```bash
terraform init -input=false
terraform fmt -check
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
```

## 核心知识（Lab 6：CLI 命令与参数速查）

- `terraform <command> -help` 查看子命令参数；常用命令包括 `init`、`validate`、`plan`、`apply` 和 `destroy`。
- 自动化常用 `-input=false`、`-no-color`、`-out` 和 `-detailed-exitcode`。
- `plan -detailed-exitcode` 的返回码：0 表示无变化，1 表示错误，2 表示存在变化。

## 最小代码（Lab 6）

```bash
terraform plan -help
terraform validate
terraform plan -input=false -no-color -detailed-exitcode
```

## 核心知识（Lab 7：`-input=false` 与非交互式失败）

- `-input=false` 不会替你补值；缺少必填变量时应立即失败。
- CI 中应通过 `-var`、`-var-file` 或环境变量显式提供输入。
- 这种“快速失败”比流水线卡在交互提示上更容易排障。

## 最小代码（Lab 7）

```bash
terraform plan \
  -input=false \
  -var="artifact_name=ci-artifact.txt" \
  -out=tfplan
terraform apply -auto-approve tfplan
```

## 核心知识（Lab 8：`-no-color` 与机器可读日志）

- Terraform 默认可能输出 ANSI 颜色码，重定向到文件后会污染纯文本。
- `-no-color` 适用于需要保存、解析或上传的 CLI 输出。
- 二进制 plan 用 `-out` 保存；可读文本使用 `terraform show -no-color` 导出。

## 最小代码（Lab 8）

```bash
terraform plan -input=false -no-color -out=tfplan
terraform show -no-color tfplan > plan.txt
```

## 核心知识（Lab 9：Provider Plugin Cache 概念）

- Plugin cache 复用已下载的 provider 包，减少重复下载和初始化时间。
- `TF_PLUGIN_CACHE_DIR` 或 CLI 配置中的 `plugin_cache_dir` 用来指定共享缓存。
- 缓存不替代 `.terraform.lock.hcl`；锁文件负责版本选择和校验和。

## 最小代码（Lab 9）

```bash
mkdir -p .terraform-plugin-cache
export TF_PLUGIN_CACHE_DIR="$PWD/.terraform-plugin-cache"
terraform init -input=false
```

## 核心知识（Lab 10：Plugin Cache 实践落地）

- `plugin_cache_dir` 属于 Terraform CLI 配置，不属于业务模块资源配置。
- `TF_CLI_CONFIG_FILE` 可让某次运行使用指定的 CLI 配置文件。
- 团队应保留 lock file，并避免默认启用破坏依赖锁兼容性的开关。

## 最小代码（Lab 10）

```hcl
# terraform.rc
plugin_cache_dir = "/workspace/.terraform-plugin-cache"
```

```bash
export TF_CLI_CONFIG_FILE="$PWD/terraform.rc"
terraform init -input=false
```

## 核心知识（Lab 11：File System Mirror 概念）

- Plugin cache 优化重复下载；filesystem mirror 决定 provider 的安装来源。
- Mirror 适合离线、内网或受控供应链环境。
- `include` 限定镜像覆盖范围，`direct.exclude` 防止指定 provider 回退到公网。

## 最小代码（Lab 11）

```hcl
provider_installation {
  filesystem_mirror {
    path    = "/workspace/mirror"
    include = ["registry.terraform.io/hashicorp/*"]
  }
  direct {
    exclude = ["registry.terraform.io/hashicorp/*"]
  }
}
```

## 核心知识（Lab 12：显式 Provider Installation）

- `provider_installation` 可以组合多个安装方法，Terraform 按匹配规则选择来源。
- 联网环境可保留 `direct` 回退；完全隔离环境应只允许受控 mirror。
- 先用 `terraform providers mirror` 准备目录，再让 `init` 使用对应 CLI 配置。

## 最小代码（Lab 12）

```bash
terraform providers mirror ./mirror
TF_CLI_CONFIG_FILE=terraform-cli.rc terraform init -input=false
```

## 核心知识（Lab 13：静态分析工具基础）

- `terraform fmt` 和 `validate` 检查格式与配置结构，但不等于安全扫描。
- TFLint、Checkov 等工具可发现质量、规范和安全风险。
- 静态扫描读取代码，无法总是知道运行时变量形成的最终 plan。

## 最小代码（Lab 13）

```bash
terraform fmt -recursive -check
terraform init -backend=false -input=false
terraform validate
checkov -d . --framework terraform
```

## 核心知识（Lab 14：Checkov 容器化安装验证）

- 工具容器可隔离 Python 依赖并统一 CI 与本地版本。
- 生产流水线应固定镜像版本，避免 `latest` 带来不可复现变化。
- 将仓库只读挂载给扫描器即可，无需创建基础设施。

## 最小代码（Lab 14）

```bash
docker run --rm \
  -v "$PWD:/tf:ro" \
  bridgecrew/checkov:3.2.0 \
  -d /tf --framework terraform
```

## 核心知识（Lab 15：Checkov 扫描选项）

- `-f` 扫描单个文件，`-d` 扫描目录。
- `--check` 只运行指定规则；`--skip-check` 排除经批准的规则。
- `--soft-fail` 只报告不阻断，适合试运行期，不应掩盖必须修复的高风险项。

## 最小代码（Lab 15）

```bash
checkov -d . --framework terraform
checkov -f main.tf --check CKV_K8S_19
checkov -d . --skip-check CKV_K8S_43
```

## 核心知识（Lab 16：保存 Plan 到文件）

- `terraform plan -out=tfplan` 生成不可直接阅读的二进制 plan。
- `terraform show tfplan` 用于人工审查，`show -json` 供自动化工具处理。
- 应用保存的 plan 时不会重新规划，从而确保执行的是已审查内容。

## 最小代码（Lab 16）

```bash
terraform plan -input=false -no-color -out=tfplan
terraform show tfplan
terraform show -json tfplan > plan.json
terraform apply -auto-approve tfplan
```

## 核心知识（Lab 17：Code Scan 与 Plan Scan）

- Code scan 尽早检查源码；plan scan 检查变量、模块和 provider 解析后的最终变更。
- 两者覆盖阶段不同，不能互相替代。
- Plan JSON 可能含敏感值，应按敏感制品保护并及时清理。

## 最小代码（Lab 17）

```bash
checkov -d . --framework terraform
terraform plan -input=false -out=tfplan -var="host_network_enabled=true"
terraform show -json tfplan > plan.json
checkov -f plan.json --framework terraform_plan
```

## 核心知识（Lab 18：`TF_IN_AUTOMATION` 与自动化日志）

- `TF_IN_AUTOMATION=true` 告诉 Terraform 当前运行在自动化环境中。
- 它会减少面向人工的下一步提示，但不会替代 `-input=false` 或 `-no-color`。
- 环境变量应在 runner 作用域设置，而不是写死在 Terraform 配置中。

## 最小代码（Lab 18）

```bash
export TF_IN_AUTOMATION=true
terraform plan -input=false -no-color
```

## 核心知识（Lab 19：Terraform import 工作流）

- Import 把已存在对象绑定到 Terraform 资源地址，不会自动证明配置与远端完全一致。
- 推荐顺序：识别 ID、编写资源配置与 `import` 块、plan、审查差异、apply。
- State 含有导入关系后，后续变更才由 Terraform 管理。

## 最小代码（Lab 19）

```hcl
import {
  to = aws_security_group.legacy
  id = "sg-0123456789abcdef0"
}

resource "aws_security_group" "legacy" {
  name = "legacy"
}
```

## 核心知识（Lab 20：导入后生成配置）

- `-generate-config-out` 可根据 import 目标生成候选 HCL，适合没有现成资源块的场景。
- 生成内容只是起点，必须清理只读、冲突、默认或不符合团队规范的参数。
- 生成文件已存在时命令会拒绝覆盖，应使用新的路径或先人工处理。

## 最小代码（Lab 20）

```hcl
import {
  to = aws_security_group.legacy
  id = var.manual_resource_id
}
```

```bash
terraform plan -generate-config-out=generated.tf
```

## 核心知识（Lab 21：Resource Targeting 基础）

- `-target` 只聚焦指定地址及其必要依赖，主要用于故障恢复或特殊维护。
- 它可能产生不完整的基础设施视图，不应成为日常部署方式。
- Targeted apply 后应再运行一次完整 `plan`，确认整体状态收敛。

## 最小代码（Lab 21）

```bash
terraform plan -target=local_file.release_note
terraform apply -target=local_file.release_note
terraform plan
```

## 核心知识（Lab 22：`random_integer` 与唯一命名）

- `random_integer` 在指定范围内生成数字，结果进入 state 并在资源不替换时保持稳定。
- 可将结果拼入需要唯一性的名称，但仍要满足目标平台命名规则。
- 删除 state 或触发资源替换会生成新值，不能把随机值当永久业务标识。

## 最小代码（Lab 22）

```hcl
resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

locals {
  artifact_name = "training-${random_integer.suffix.result}"
}
```

## 核心知识（Lab 23：Targeting 与依赖方向）

- Terraform 根据表达式引用建立依赖图；下游引用上游属性时形成隐式依赖。
- Target 下游资源时，Terraform 会把它所需的上游依赖纳入计划。
- Target 上游资源不会自动包含所有下游消费者，依赖方向不能反推。

## 最小代码（Lab 23）

```hcl
resource "random_integer" "build" {
  min = 100
  max = 999
}

resource "local_file" "manifest" {
  filename = "manifest-${random_integer.build.result}.txt"
  content  = tostring(random_integer.build.result)
}
```

## 核心知识（Lab 24：`moved` Block 与资源重命名）

- 重命名资源会改变 state 地址；没有迁移声明时可能出现销毁再创建。
- `moved` 把旧地址映射到新地址，只调整 Terraform 的地址认知。
- 先迁移并确认 plan 无重建，再在后续版本考虑移除历史声明。

## 最小代码（Lab 24）

```hcl
moved {
  from = terraform_data.database_firewall
  to   = terraform_data.payment_database_firewall
}

resource "terraform_data" "payment_database_firewall" {
  input = { name = "payment-db" }
}
```

## 核心知识（Lab 25：Quoted String 与转义序列）

- 双引号字符串用 `\"` 表示引号、`\\` 表示反斜杠、`\n` 表示换行。
- `${...}` 执行字符串插值；需要字面量 `${` 时使用 `$${`。
- 短文本适合 quoted string，多行内容优先使用 heredoc。

## 最小代码（Lab 25）

```hcl
locals {
  message = "协作者是 \"Alice\" 和 \"Bob\"。\n"
  path    = "C:\\terraform\\training"
  literal = "保留插值标记：$${service_name}"
}
```

## 核心知识（Lab 26：Heredoc 多行字符串）

- `<<EOT` 到独占一行的 `EOT` 之间是多行字符串。
- Heredoc 支持 Terraform 插值，适合脚本、策略和配置模板。
- 结束标记必须匹配；普通 heredoc 会保留正文前导空白。

## 最小代码（Lab 26）

```hcl
locals {
  deploy_script = <<EOT
set -eu
echo "开始部署 ${path.module}"
echo "完成部署"
EOT
}
```

## 核心知识（Lab 27：基础与 Indented Heredoc）

- `<<EOT` 保留正文缩进；`<<-EOT` 会删除所有非空行共有的最小前导空白。
- Indented heredoc 允许结束标记随 HCL 结构缩进，代码更易读。
- 它不会删除每一行的全部缩进，额外的相对缩进仍保留。

## 最小代码（Lab 27）

```hcl
locals {
  text = <<-EOT
    line-one
      line-two
    line-three
  EOT
}
```

## 核心知识（Lab 28：Indented Heredoc 前导空白规则）

- Terraform 先找出所有非空行的最小缩进，再统一删除该宽度。
- 更深层级的相对空白会保留，因此适合生成 YAML 等层级文本。
- 可用 `split()`、`trimspace()` 检查最终行结构。

## 最小代码（Lab 28）

```hcl
locals {
  yaml = <<-EOT
    app:
      name: payments
    env: prod
  EOT

  lines = split("\n", trimspace(local.yaml))
}
```

## 核心知识（Lab 29：`jsonencode` 与 `jsondecode`）

- `jsonencode` 把 Terraform 值安全编码为 JSON，避免手工拼接转义。
- `jsondecode` 把 JSON 字符串转换成可访问的 object、tuple 等 Terraform 值。
- `file()` 读取的是字符串，通常与 `jsondecode(file(...))` 组合使用。

## 最小代码（Lab 29）

```hcl
locals {
  encoded = jsonencode({ name = "payments", ports = [8080, 9090] })
  decoded = jsondecode(file("${path.module}/data/service.json"))
}
```

## 核心知识（Lab 30：从 JSON 提取指定字段）

- 解码后可用属性访问、索引和 `for ... if` 筛选嵌套数据。
- 先保存中间结果能让复杂表达式更清晰，也更方便测试。
- 不要假定筛选结果一定非空；生产代码可结合 `try()`、`one()` 或显式校验。

## 最小代码（Lab 30）

```hcl
locals {
  catalog = jsondecode(file("${path.module}/data/catalog.json"))
  backends = [
    for service in local.catalog.services : service
    if service.tier == "backend"
  ]
  backend_ports = local.backends[0].ports
}
```

## 核心知识（Lab 31：读取已有 EC2 实例列表）

- Data source 读取已存在对象，不会把查询结果变成 Terraform 管理的 resource。
- `aws_instances` 返回多个实例 ID，可用多个 `filter` 共同缩小范围。
- 输出列表和 `length()` 能直接验证查询数量。

## 最小代码（Lab 31）

```hcl
data "aws_instances" "lab" {
  filter {
    name   = "tag:Project"
    values = ["tf-lab-31"]
  }
}

output "instance_count" {
  value = length(data.aws_instances.lab.ids)
}
```

## 核心知识（Lab 32：区分 Resource 与 Data Source）

- `resource` 创建并管理对象；`data` 只读取 provider 已知信息。
- Data source 仍会调用 provider API，但不会产生对应的受管资源地址。
- `aws_caller_identity` 与 `aws_region` 常用于动态获取账号和区域上下文。

## 最小代码（Lab 32）

```hcl
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

output "context" {
  value = {
    account = data.aws_caller_identity.current.account_id
    region  = data.aws_region.current.name
  }
}
```

## 核心知识（Lab 33：单实例与多实例 Data Source）

- `aws_instance` 期望精确匹配一台实例并返回详细属性。
- `aws_instances` 返回一组 ID，适合列表查询。
- 过滤条件必须足够精确；不应依赖结果列表的偶然顺序选择单个对象。

## 最小代码（Lab 33）

```hcl
data "aws_instance" "production" {
  filter {
    name   = "tag:Team"
    values = ["production"]
  }
}

data "aws_instances" "all_lab" {
  filter {
    name   = "tag:Project"
    values = ["tf-lab-33"]
  }
}
```

## 核心知识（Lab 34：避免硬编码 AMI）

- `aws_ami` 可按 owner、名称、架构等条件动态选择镜像。
- `most_recent = true` 在匹配集合中选择最新项；过滤条件过宽可能选到意外镜像。
- 生产环境应使用可信 owner，并理解“最新镜像”可能触发实例替换。

## 最小代码（Lab 34）

```hcl
data "aws_ami" "latest" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["tf-lab-ubuntu-*-x86_64"]
  }
}
```

## 核心知识（Lab 35：使用动态 AMI 创建 EC2）

- Resource 可直接引用 data source 属性，由 Terraform 建立读取到创建的依赖。
- AMI ID 不再硬编码，但 plan 时仍会解析为确定值。
- 新 AMI 成为“最新”后，下次 plan 可能计划替换 EC2。

## 最小代码（Lab 35）

```hcl
data "aws_ami" "latest" {
  most_recent = true
  owners      = ["self"]
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.latest.id
  instance_type = "t3.micro"
}
```

## 核心知识（Lab 36：输入变量验证基础）

- `validation` 在规划前拒绝无效输入，让错误靠近输入源。
- 白名单用 `contains()`，数值范围用比较表达式。
- 错误信息应明确说明允许值或有效范围。

## 最小代码（Lab 36）

```hcl
variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment 只能是 dev、staging 或 prod。"
  }
}
```

## 核心知识（Lab 37：密码长度验证）

- 敏感输入应标记 `sensitive = true`，使常规 CLI 展示脱敏。
- `length()` 可执行最小长度校验，但真实密码策略还应考虑来源和轮换。
- Sensitive 标记不会从 state 中移除值；state 和 plan 仍需严格保护。

## 最小代码（Lab 37）

```hcl
variable "db_password" {
  type      = string
  sensitive = true

  validation {
    condition     = length(var.db_password) >= 12
    error_message = "密码至少需要 12 个字符。"
  }
}
```

## 核心知识（Lab 38：多条件变量验证）

- 每个变量可拥有独立 validation，使错误归因更清楚。
- 枚举型参数应使用明确白名单，避免任意字符串流入资源配置。
- 多个约束可以写在同一条件中，也可拆成多个 validation block。

## 最小代码（Lab 38）

```hcl
variable "instance_size" {
  type = string
  validation {
    condition     = contains(["small", "medium", "large"], var.instance_size)
    error_message = "instance_size 无效。"
  }
}
```

## 核心知识（Lab 39：Precondition 与 Postcondition）

- Precondition 在对象操作前验证前提，可引用变量、locals 和其他对象。
- Postcondition 在对象求值后验证结果，通过 `self` 引用当前对象。
- 条件失败会阻止相应操作，适合表达资源级业务约束。

## 最小代码（Lab 39）

```hcl
resource "terraform_data" "compute" {
  input = { size = var.instance_size }

  lifecycle {
    precondition {
      condition     = contains(["small", "medium"], var.instance_size)
      error_message = "只允许 small 或 medium。"
    }
    postcondition {
      condition     = contains(["small", "medium"], self.output.size)
      error_message = "创建结果规格无效。"
    }
  }
}
```

## 核心知识（Lab 40：文件存在性 Precondition）

- `fileexists()` 检查静态输入文件是否存在，`file()` 读取其内容。
- `try()` 可把文件缺失或读取失败转换为可控的布尔结果。
- Precondition 应在创建依赖该文件的资源前给出明确错误。

## 最小代码（Lab 40）

```hcl
locals {
  db_file_ready = try(
    length(trimspace(file("${path.module}/input/db.txt"))) > 0,
    false
  )
}

resource "local_file" "app" {
  filename = "output/app.txt"
  content  = "ready"
  lifecycle {
    precondition {
      condition     = local.db_file_ready
      error_message = "input/db.txt 必须存在且非空。"
    }
  }
}
```

## 核心知识（Lab 41：Check Block）

- `check` 用于持续验证基础设施或服务契约，不属于某个资源的生命周期。
- Check 失败通常报告警告，不会像 precondition 那样阻断当前 plan/apply。
- 适合健康检查、证书状态或跨资源一致性等运行期断言。

## 最小代码（Lab 41）

```hcl
check "service_url_contract" {
  assert {
    condition     = startswith(var.service_url, "https://")
    error_message = "生产服务地址必须使用 HTTPS。"
  }
}
```

## 核心知识（Lab 42：Sensitive 参数）

- Sensitive 输入会把依赖它的表达式一并传播为敏感值。
- `nonsensitive()` 只能用于确认安全的派生信息，不能用来强行暴露秘密原文。
- Output 的脱敏只影响显示；秘密仍可能存在 state、plan 和 provider 日志中。

## 最小代码（Lab 42）

```hcl
variable "api_token" {
  type      = string
  sensitive = true
}

output "token_is_configured" {
  value = nonsensitive(length(trimspace(var.api_token)) > 0)
}

output "api_token" {
  value     = var.api_token
  sensitive = true
}
```

## 核心知识（Lab 43：HashiCorp Vault 基础）

- Vault 用 secret engine 保存秘密，并通过 policy 与 token 控制访问。
- KV v2 的逻辑路径与 CLI/API 路径存在版本化差异，应区分 mount 和 secret name。
- 若 Terraform 读取秘密原文，值通常会进入 state；只验证路径可用时应避免读取原文。

## 最小代码（Lab 43）

```bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
vault secrets enable -path=training kv-v2
vault kv put training/db_creds username=app password=secret
vault kv get training/db_creds
```

## 核心知识（Lab 44：Vault Provider）

- Vault provider 需要地址和认证 token；token 应通过安全注入而非硬编码。
- `vault_mount` 管理 secret engine，`vault_kv_secret_v2` 管理 KV v2 数据。
- 通过 provider 读写的秘密可能以明文存在 state，必须评估是否应由 Terraform 管理。

## 最小代码（Lab 44）

```hcl
provider "vault" {
  address = var.vault_addr
  token   = var.vault_token
}

resource "vault_mount" "training" {
  path = "training"
  type = "kv-v2"
}

resource "vault_kv_secret_v2" "db" {
  mount     = vault_mount.training.path
  name      = "db_creds"
  data_json = jsonencode({ username = "app", password = var.db_password })
}
```

## 核心知识（Lab 45：EC2 资源行为与 Meta-argument）

- `for_each` 用稳定业务键控制资源集合，新增或删除 key 对应创建或销毁实例。
- `create_before_destroy` 改变需要替换时的操作顺序。
- `replace_triggered_by` 可把另一个受管对象的变化声明为替换触发条件。

## 最小代码（Lab 45）

```hcl
resource "aws_instance" "web" {
  for_each      = var.desired_ec2_instances
  ami           = var.ami_id
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
    replace_triggered_by  = [terraform_data.ami_rollout]
  }
}
```

## 核心知识（Lab 46：Lifecycle Meta-argument）

- `create_before_destroy` 控制替换顺序；`prevent_destroy` 阻止销毁计划。
- `ignore_changes` 忽略指定属性的后续差异；应精确到真正由外部系统管理的字段。
- `replace_triggered_by` 根据其他受管资源变化强制替换当前对象。

## 最小代码（Lab 46）

```hcl
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tags["Owner"]]
    replace_triggered_by  = [terraform_data.ami_rollout]
  }
}
```

## 核心知识（Lab 47：替换顺序与 `triggers_replace`）

- `terraform_data.triggers_replace` 的值变化会替换该对象。
- Plan 中 `-/+` 表示先销毁后创建，`+/-` 表示先创建替代对象后销毁旧对象。
- `create_before_destroy` 可能沿依赖图传播，应确认目标平台允许新旧对象短暂并存。

## 最小代码（Lab 47）

```hcl
resource "terraform_data" "release" {
  input            = { image_version = var.image_version }
  triggers_replace = var.image_version

  lifecycle {
    create_before_destroy = true
  }
}
```

## 核心知识（Lab 48：`prevent_destroy` 与 State 清理）

- `prevent_destroy = true` 阻止 Terraform 计划销毁受保护资源。
- 规则必须写在要保护的 resource 内；它不阻止创建或普通原地更新。
- `terraform state rm` 解除管理关系但不删除真实对象，属于需要谨慎执行的逃生操作。

## 最小代码（Lab 48）

```hcl
resource "local_file" "critical_config" {
  filename = "output/critical-config.txt"
  content  = "critical_config=true\n"

  lifecycle {
    prevent_destroy = true
  }
}
```

```bash
terraform state rm local_file.critical_config
```

## 核心知识（Lab 49：状态漂移与 `ignore_changes`）

- Drift 是远端对象被 Terraform 之外的流程修改后，与配置或 state 出现差异。
- `ignore_changes` 告诉 Terraform 不再纠正指定属性的更新差异。
- 应只忽略明确由外部系统负责的字段，避免 `all` 掩盖真实配置漂移。

## 最小代码（Lab 49）

```hcl
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags          = { Owner = "terraform" }

  lifecycle {
    ignore_changes = [tags["Owner"]]
  }
}
```

## 核心知识（Lab 50：List 数据类型）

- List 是有顺序、可重复、元素类型一致的集合，用 `[]` 定义。
- 通过从 0 开始的索引读取元素，`length()` 返回数量。
- `for` 表达式可保留顺序并转换每个元素。

## 最小代码（Lab 50）

```hcl
locals {
  regions = ["ap-southeast-2", "ap-southeast-1", "us-east-1"]
  primary = local.regions[0]
  labels  = [for i, region in local.regions : "${i}:${region}"]
}
```

## 核心知识（Lab 51：Map 数据类型）

- Map 是同类型值组成的 key/value 集合，适合标签和按名称索引的数据。
- 可用 `map["key"]`、`keys()`、`values()` 和 `length()` 操作。
- `lookup(map, key, default)` 为缺失的可选 key 提供回退值。

## 最小代码（Lab 51）

```hcl
locals {
  tags         = { owner = "platform", env = "dev" }
  owner        = local.tags["owner"]
  tag_keys     = keys(local.tags)
  service_name = lookup(local.tags, "service", "checkout")
}
```

## 核心知识（Lab 52：Object 数据类型）

- Object 用固定属性名表达一个结构，属性可以拥有不同类型。
- 使用点号读取属性，并可继续访问嵌套 map、list 或 object。
- 变量类型写成 `object({...})` 时，Terraform 会校验完整结构。

## 最小代码（Lab 52）

```hcl
locals {
  service = {
    name    = "payments"
    port    = 8080
    enabled = true
    tags    = { owner = "platform" }
    zones   = ["az-a", "az-b"]
  }
  endpoint = "${local.service.name}:${local.service.port}"
}
```

## 核心知识（Lab 53：List of Objects 与嵌套值）

- `list(object)` 适合保存结构相同的多条业务记录。
- 两层索引可读取 object 内的 list；嵌套 `for` 可遍历服务与端口。
- `flatten()` 将嵌套 list 合并成一层，map 推导式可按名称建立索引。

## 最小代码（Lab 53）

```hcl
locals {
  services = [
    { name = "api", ports = [8080, 9090] },
    { name = "worker", ports = [9000] }
  ]
  by_name = { for service in local.services : service.name => service }
  labels = flatten([
    for service in local.services : [
      for port in service.ports : "${service.name}:${port}"
    ]
  ])
}
```

## 核心知识（Lab 54：Map of Objects 与嵌套读取）

- `map(object)` 结合稳定业务键和结构化属性，适合环境配置。
- 可连续使用点号或中括号读取深层属性。
- `keys()` 返回可遍历的环境名称，`for key, value in map` 同时取得两者。

## 最小代码（Lab 54）

```hcl
locals {
  environments = {
    dev  = { region = "local", replicas = 1 }
    prod = { region = "ap-southeast-2", replicas = 3 }
  }
  prod_replicas = local.environments.prod.replicas
  labels = [
    for name, env in local.environments : "${name}:${env.region}"
  ]
}
```

## 核心知识（Lab 55：`count` 与索引）

- `count` 根据整数创建多个同类实例，地址包含 `[index]`。
- `count.index` 从 0 开始，可用于读取平行 list 或生成名称。
- List 中间插入或排序变化可能导致多个索引地址漂移；稳定业务键更适合 `for_each`。

## 最小代码（Lab 55）

```hcl
locals {
  users = ["user-01", "user-02", "user-03"]
}

resource "terraform_data" "user" {
  count = length(local.users)
  input = {
    name  = local.users[count.index]
    index = count.index
  }
}
```

## 核心知识（Lab 56：Map 函数与遍历）

- `keys()` 和 `values()` 分别提取 map 的键和值。
- Map 迭代可直接得到 key/value，并转换成 list 或另一个 map。
- `lookup()` 适合可选键；必需键应直接访问并让缺失尽早失败。

## 最小代码（Lab 56）

```hcl
locals {
  ports   = { api = 8080, worker = 9000, web = 8081 }
  names   = keys(local.ports)
  numbers = values(local.ports)
  labels  = [for name, port in local.ports : "${name}:${port}"]
}
```

## 核心知识（Lab 57：`for_each` 基础）

- `for_each` 接受 map 或 set，实例地址使用稳定 key。
- `each.key` 是实例键，`each.value` 是对应值。
- 删除一个 key 只影响对应实例，通常比依赖 list 索引的 `count` 更稳定。

## 最小代码（Lab 57）

```hcl
resource "terraform_data" "service" {
  for_each = {
    api    = "api service"
    worker = "worker service"
  }

  input = {
    name    = each.key
    content = each.value
  }
}
```

## 核心知识（Lab 58：条件表达式）

- 条件表达式格式为 `condition ? true_value : false_value`。
- 两个结果必须能转换为一致类型。
- `for ... if` 用于过滤集合，与二选一条件表达式用途不同。

## 最小代码（Lab 58）

```hcl
locals {
  environment   = "prod"
  instance_size = local.environment == "prod" ? "large" : "small"
  base_tags     = { owner = "platform" }
  tags = local.environment == "prod" ? merge(
    local.base_tags,
    { critical = "true" }
  ) : local.base_tags
}
```

## 核心知识（Lab 59：`for` 表达式基础）

- List 推导式使用 `[for item in list : result]`。
- Map 推导式使用 `{ for item in list : key => value }`。
- 末尾 `if` 可过滤元素；双变量形式可同时取得索引或 map key。

## 最小代码（Lab 59）

```hcl
locals {
  users       = ["alice", "bob", "john"]
  upper_users = [for user in local.users : upper(user)]
  short_users = [for user in local.users : user if length(user) <= 4]
  user_lookup = { for user in local.users : user => upper(user) }
}
```

## 核心知识（Lab 60：`csvdecode` 基础）

- `csvdecode()` 将 CSV 解析为 object list，首行必须是字段名。
- CSV 字段全部先成为字符串；端口、布尔语义等需要显式转换或比较。
- `path.module` 确保文件路径相对于当前模块，而不是调用终端的目录。

## 最小代码（Lab 60）

```hcl
locals {
  services = csvdecode(file("${path.module}/data/services.csv"))
  ports    = [for service in local.services : tonumber(service.port)]
  enabled = [
    for service in local.services : service.name
    if service.enabled == "true"
  ]
}
```

## 核心知识（Lab 61：进阶 `for` 与分组模式）

- Map 推导中相同 key 默认报 duplicate key。
- 在 value 后写 `...` 启用 grouping mode，把同 key 的多个值收集为 list。
- 嵌套循环通常先产生 list of lists，再用 `flatten()` 展平。

## 最小代码（Lab 61）

```hcl
locals {
  services = [
    { name = "api", tier = "frontend", ports = [8080, 9090] },
    { name = "web", tier = "frontend", ports = [8081] }
  ]
  names_by_tier = {
    for service in local.services : service.tier => service.name...
  }
}
```

## 核心知识（Lab 62：组合筛选、分组与复合键）

- 多个条件可用 `&&` 组合，生成只含启用生产应用的结果。
- `team/name` 等复合 key 可把层级业务标识转换成稳定 map。
- 复杂转换应拆成命名清楚的 locals，避免一条表达式承担全部逻辑。

## 最小代码（Lab 62）

```hcl
locals {
  enabled_prod_regions = {
    for app in local.applications : app.name => app.regions[0]
    if app.enabled && app.environment == "prod"
  }
  environment_by_path = {
    for app in local.applications :
    "${app.team}/${app.name}" => app.environment
  }
}
```

## 核心知识（Lab 63：嵌套 `for` 表达式）

- 多个集合的笛卡尔组合可用嵌套 `for` 生成。
- 嵌套 map 可通过 `merge([for ... : {...}]...)` 合并为扁平 map。
- 生成的 key 必须唯一，否则 map 推导失败。

## 最小代码（Lab 63）

```hcl
locals {
  regions = ["local-a", "local-b"]
  apps    = ["api", "worker"]

  combinations = flatten([
    for region in local.regions : [
      for app in local.apps : {
        name   = "${region}-${app}"
        region = region
        app    = app
      }
    ]
  ])
}
```

## 核心知识（Lab 64：`flatten` 与 `distinct`）

- `flatten()` 递归展平直接嵌套的 list。
- `distinct()` 保留首次出现顺序并删除重复值。
- 常见流程是先展平多组数据，再去重并计算数量。

## 最小代码（Lab 64）

```hcl
locals {
  groups = [
    ["api", "worker"],
    ["api", "billing"]
  ]
  all_services    = flatten(local.groups)
  unique_services = distinct(local.all_services)
}
```

## 核心知识（Lab 65：`templatefile` 基础）

- `templatefile(path, vars)` 读取模板并用 map 提供变量。
- 模板路径应基于 `path.module`；模板文件不是自动参与 Terraform 配置的 `.tf`。
- 对 JSON 等结构化格式优先在模板中调用 `jsonencode`，避免手工转义。

## 最小代码（Lab 65）

```hcl
locals {
  rendered = templatefile("${path.module}/service.tftpl", {
    name        = "payments"
    environment = "dev"
  })
}

resource "local_file" "service" {
  filename = "output/service.txt"
  content  = local.rendered
}
```

## 核心知识（Lab 66：模板中的 Map 与循环）

- 模板指令 `%{ for ... }`、`%{ if ... }` 控制重复和条件内容。
- 调用方先用 `keys()` 得到稳定名称列表，模板再通过 key 读取 map。
- `~` 可裁剪指令边缘空白，需检查最终换行是否符合预期。

## 最小代码（Lab 66）

```text
%{ for name in names ~}
${name}=${services[name]}
%{ endfor ~}
```

```hcl
locals {
  rendered = templatefile("${path.module}/services.tftpl", {
    names    = keys(local.service_ports)
    services = local.service_ports
  })
}
```

## 核心知识（Lab 67：JSON Mock 数据与 `for`）

- 本地 JSON 可模拟 API 数据，便于练习筛选和结构转换。
- List 可筛选成名称列表，也可转换为按名称索引的 map。
- 遍历 object 内部 list 时使用嵌套 `for` 与 `flatten()`。

## 最小代码（Lab 67）

```hcl
locals {
  apps = jsondecode(file("${path.module}/data/mock.json")).apps
  backends = [
    for app in local.apps : app.name
    if app.tier == "backend"
  ]
  enabled_by_name = {
    for app in local.apps : app.name => app if app.enabled
  }
}
```

## 核心知识（Lab 68：CSV 驱动 Ingress/Egress Rule）

- 解码 CSV 后先按 direction 分组，再构造唯一 key map 供 `for_each` 使用。
- `tonumber()` 把端口字符串转换为 provider 期望的 number。
- 一行输入驱动一个资源，使增删规则可在 plan 中清晰审查。

## 最小代码（Lab 68）

```hcl
locals {
  rules = csvdecode(file("${path.module}/data/sg.csv"))
  ingress = {
    for rule in local.rules : rule.name => rule
    if rule.direction == "in"
  }
}

resource "terraform_data" "ingress" {
  for_each = local.ingress
  input = {
    from_port = tonumber(each.value.from_port)
    to_port   = tonumber(each.value.to_port)
  }
}
```

## 核心知识（Lab 69：CSV 重名与 Index Key）

- 非唯一名称不能直接作为 map 或 `for_each` key，否则产生 duplicate key。
- 双变量 `for index, rule in list` 可使用索引建立唯一地址。
- 索引 key 解决重复，但输入重排会改变地址；生产数据最好提供稳定唯一 ID。

## 最小代码（Lab 69）

```hcl
locals {
  ingress = [
    for rule in local.rules : rule if rule.direction == "ingress"
  ]
  ingress_by_index = {
    for index, rule in local.ingress : index => rule
  }
}

resource "terraform_data" "rule" {
  for_each = local.ingress_by_index
  input    = each.value
}
```

## 核心知识（Lab 70：CSV 端口范围与唯一键）

- 单端口和 `start-end` 范围需要归一化成 `from_port`、`to_port`。
- `can(regex())` 可安全判断格式，`split()` 拆分边界，`tonumber()` 转换类型。
- 名称不唯一时可组合业务字段和索引形成 key。

## 最小代码（Lab 70）

```hcl
locals {
  processed = [
    for rule in local.csv_data : merge(rule, {
      from_port = tonumber(split("-", rule.port)[0])
      to_port   = can(regex("-", rule.port)) ? tonumber(split("-", rule.port)[1]) : tonumber(rule.port)
    })
  ]
  by_key = {
    for i, rule in local.processed : "${rule.name}-${i}" => rule
  }
}
```

## 核心知识（Lab 71：CSV 与 JSON 联表）

- CSV 可保存规则，JSON map 可保存别名到 CIDR 的查找表。
- 用 `lookup_map[rule.alias]` 执行内存联表，不应把解析结果手工复制到代码。
- 两端命名不一致时加入明确 mapping 层，便于审计和迁移。

## 最小代码（Lab 71）

```hcl
locals {
  rules = csvdecode(file("${path.module}/data/rules.csv"))
  cidrs = jsondecode(file("${path.module}/data/cidrs.json"))
  mapped = {
    for rule in local.rules : rule.name => {
      cidr = local.cidrs[local.name_mapping[rule.cidr_alias]]
      port = tonumber(rule.port)
    }
  }
}
```

## 核心知识（Lab 72：Terraform Settings 与版本约束）

- `required_version` 约束 Terraform CLI；`required_providers` 声明 provider source 和版本范围。
- `terraform` block 管项目级行为，`provider` block 配运行时 region、profile、endpoint 等。
- Lock file 记录实际选中的 provider 版本，不能替代版本约束。

## 最小代码（Lab 72）

```hcl
terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.87"
    }
  }
}
```

## 核心知识（Lab 73：LocalStack S3 Backend 与 Remote State）

- Backend 负责 Terraform state，AWS provider 负责业务资源；两者配置相互独立。
- S3 state bucket 必须在主配置 `init` 前由 bootstrap 或外部流程创建。
- Consumer 使用 `terraform_remote_state` 读取根 output，不会接管上游资源。

## 最小代码（Lab 73）

```hcl
terraform {
  backend "s3" {
    bucket           = "tfstate-lab73"
    key              = "lab73/terraform.tfstate"
    region           = "us-east-1"
    endpoint         = "http://localhost:4566"
    force_path_style = true
  }
}

data "terraform_remote_state" "upstream" {
  backend = "s3"
  config = {
    bucket = "tfstate-lab73"
    key    = "lab73/terraform.tfstate"
    region = "us-east-1"
  }
}
```

## 核心知识（Lab 74：S3 Remote Backend）

- 空的 `backend "s3" {}` 声明后端类型，环境参数可放在单独的 backend 配置文件。
- `backend.hcl` 不会自动加载，必须通过 `init -backend-config` 传入。
- Backend 参数在变量和 locals 之前解析，不能引用普通 Terraform 表达式。

## 最小代码（Lab 74）

```hcl
# backend.tf
terraform {
  backend "s3" {}
}
```

```hcl
# backend.hcl
bucket = "tf-pro-state"
key    = "labs/74/terraform.tfstate"
region = "us-east-1"
```

```bash
terraform init -backend-config=backend.hcl
```

## 核心知识（Lab 75：DynamoDB 旧式 State Locking）

- S3 保存 state，DynamoDB table 在旧式方案中保存锁与 digest 信息。
- `dynamodb_table` 已属于遗留配置；阅读它是为了维护旧系统。
- 锁表必须预先存在，且并发操作必须连接到同一 backend 配置。

## 最小代码（Lab 75）

```hcl
bucket         = "tf-pro-state"
key            = "labs/75/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-locks"
```

## 核心知识（Lab 76：S3 Lockfile）

- `use_lockfile = true` 让 S3 backend 用锁对象协调并发写入，无需 DynamoDB。
- 此功能要求支持它的 Terraform 版本；本仓库 Lab 使用 Terraform 1.12+。
- `.tflock` 是持锁期间的过程对象，不应依赖它长期存在。

## 最小代码（Lab 76）

```hcl
bucket       = "tf-pro-state"
key          = "labs/76/terraform.tfstate"
region       = "us-east-1"
use_lockfile = true
```

## 核心知识（Lab 77：查看远端 State）

- `state list` 列出地址，`state show` 查看单个实例，`state pull` 获取完整 state JSON。
- 这些命令通过当前初始化的 backend 工作，本地不一定存在 state 文件。
- State 可能包含敏感信息；应只读检查，不能手工编辑后端对象。

## 最小代码（Lab 77）

```bash
terraform state list
terraform state show terraform_data.state_audit
terraform state pull > state-audit.json
```

## 核心知识（Lab 78：读取上游 Remote State）

- `terraform_remote_state` 是内置 data source，用 backend 配置定位另一份 state。
- 只能通过 `outputs` 访问上游根模块显式输出。
- 上游必须先 apply；consumer 自己的 backend 与它读取的上游 backend 是两个概念。

## 最小代码（Lab 78）

```hcl
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "tf-pro-state"
    key    = "labs/78/network/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  public_cidr = data.terraform_remote_state.network.outputs.public_cidr
}
```

## 核心知识（Lab 79：Remote State 串联 Network 与 Security）

- 下游不仅能读取 output，还能用它生成自己的资源输入。
- 上下游 state 保持隔离，降低锁竞争和变更爆炸半径。
- Remote state 消费者对上游 output contract 有依赖，重命名或删 output 前需协调。

## 最小代码（Lab 79）

```hcl
resource "terraform_data" "security_rule" {
  input = {
    allowed_cidr = data.terraform_remote_state.network.outputs.public_cidr
    owner        = data.terraform_remote_state.network.outputs.network_owner
    action       = "allow"
  }
}
```

## 核心知识（Lab 80：`terraform test` 入门）

- `terraform test` 发现并运行 `.tftest.hcl` 或 `.tftest.json`。
- 每个 `run` 是一个场景；`command = plan` 不创建真实对象。
- `variables` 注入场景输入，`assert` 验证 output 或配置值。

## 最小代码（Lab 80）

```hcl
run "valid_name" {
  command = plan

  variables {
    bucket_name = "hi-from-zeal"
  }

  assert {
    condition     = output.is_bucket_name_valid
    error_message = "bucket name 应通过校验。"
  }
}
```

## 核心知识（Lab 81：测试文件与 Run Block）

- 测试文件可位于根目录或默认 `tests/` 目录，文件扩展名必须正确。
- 一个测试文件可包含多个 run；未指定 `command` 时使用 apply 风格执行。
- `-test-directory` 可指定其他测试目录，但普通错误目录名不会自动发现。

## 最小代码（Lab 81）

```text
main.tf
tests/
  contract.tftest.hcl
  workflow.tftest.json
```

```hcl
run "plan_contract" {
  command = plan
}
```

## 核心知识（Lab 82：Test Assert 断言）

- 一个 run 可包含多个细粒度 `assert`，失败时分别输出对应错误信息。
- `condition` 必须得到 bool；应验证真实表达式而不是硬编码 `true`。
- Plan 测试适合验证变量、资源参数和 output，不产生远端成本。

## 最小代码（Lab 82）

```hcl
run "bucket_name_contract" {
  command = plan

  assert {
    condition     = length(var.s3_bucket_name) > 3
    error_message = "名称长度必须大于 3。"
  }
  assert {
    condition     = length(var.s3_bucket_name) < 63
    error_message = "名称长度必须小于 63。"
  }
}
```

## 核心知识（Lab 83：测试文件根级属性）

- 测试文件根级 `variables` 可覆盖主配置默认值，并供多个 run 共用。
- 测试文件也可定义自己的 provider 配置。
- 根级使用复数 `variables`；普通配置声明输入时使用单数 `variable` block。

## 最小代码（Lab 83）

```hcl
provider "local" {}

variables {
  firewall_name = "test-firewall"
  environment   = "test"
  region_label  = "ap-south-1"
}

run "uses_test_values" {
  command = plan
  assert {
    condition     = output.environment == "test"
    error_message = "测试变量未生效。"
  }
}
```

## 核心知识（Lab 84：Modules 与 DRY 复用）

- Root module 用多个 `module` block 调用同一个 child module，实现标准化而非复制。
- 输入定义可配置差异，output 形成稳定的调用契约。
- `merge()` 组合公共与模块标准标签，调用方可继续汇总多个模块输出。

## 最小代码（Lab 84）

```hcl
module "payments_api" {
  source       = "./modules/service_template"
  service_name = "payments-api"
  ports        = [8080, 9090]
  extra_tags   = local.common_tags
}

locals {
  services = [module.payments_api.service_record]
}
```

## 核心知识（Lab 85：Module 调用与 EC2 蓝图）

- Root module 只负责传入名称、AMI、规格和标签，不需要知道 child module 的内部资源实现。
- `module.<name>.<output>` 是调用方读取模块结果的唯一正式入口。
- 在使用公开模块前应检查输入、默认行为、资源数量和销毁成本。

## 最小代码（Lab 85）

```hcl
module "ec2" {
  source           = "./modules/ec2_instance_blueprint"
  name             = "training-web-01"
  ami_id           = "ami-0123456789abcdef0"
  instance_type    = "t3.micro"
  enable_public_ip = false
}

output "instance_config" {
  value = module.ec2.instance_config
}
```

## 核心知识（Lab 86：引用 Module 前的输入与结构判断）

- Module source 可指向仓库根模块，也可用 `//modules/...` 指向子模块。
- 调用前必须阅读 required inputs、provider 要求、预期资源和版本文档。
- 不能根据仓库名称假设模块可直接 plan/apply；缺少环境输入时应显式传入。

## 最小代码（Lab 86）

```hcl
locals {
  missing_inputs = [
    for input in local.module.required_inputs : input
    if !contains(keys(local.provided_inputs), input)
  ]
  uses_submodule = local.module.module_path != "root"
}
```

## 核心知识（Lab 87：选择合适的 Registry Module）

- 评估下载量、维护者、版本发布、文档、issue 和源码，而不是只看搜索排名。
- `for ... if` 可将候选项分类为可信、需审查或不适用。
- 版本应固定或约束，并在升级前审查 changelog 与 plan。

## 最小代码（Lab 87）

```hcl
locals {
  trusted = {
    for module in local.modules : module.name => module
    if module.has_documentation
    && module.contributors >= 5
    && module.version_count >= 3
    && !module.source_review_required
  }
}
```

## 核心知识（Lab 88：组织内部 Module 目录结构）

- `modules/` 存放平台维护的可复用组件，团队目录或独立仓库作为消费方。
- 同仓库相对 source 简单，但跨仓库 Git source + tag 更利于独立版本管理。
- Module 应按职责边界拆分，避免把网络、计算、IAM 和数据库堆进一个巨型模块。

## 最小代码（Lab 88）

```text
modules/
  ec2/
  security-group/
teams/
  team-a/
  team-b/
```

## 核心知识（Lab 89：创建第一个 EC2 Module）

- 最小 child module 由输入、资源和 output 构成，只暴露当前需要的能力。
- Root module 的 `source` 指向模块目录。
- 内部模块应从小而清晰开始，避免复制公开模块的全部选项。

## 最小代码（Lab 89）

```hcl
# root
module "team_a_ec2" {
  source = "./modules/ec2"
}

# modules/ec2/main.tf
resource "terraform_data" "instance" {
  input = { name = "team-a-web", instance_type = "t2.micro" }
}

output "instance_config" {
  value = terraform_data.instance.output
}
```

## 核心知识（Lab 90：Module Sources）

- `source` 可使用本地路径、Registry、Git、HTTP archive、S3 等来源。
- 只有 Registry module 的 `version` 参数支持 Registry 版本选择；Git 常用 `?ref=tag`。
- 修改 module source 或版本后通常需要重新运行 `terraform init`。

## 最小代码（Lab 90）

```hcl
module "local" {
  source = "./modules/service"
}

module "registry" {
  source  = "hashicorp/consul/aws"
  version = "~> 0.11"
}

module "git" {
  source = "git::https://example.com/platform/network.git?ref=v1.2.0"
}
```

## 核心知识（Lab 91：Local Path Module Reference）

- 本地 module source 必须以 `./` 或 `../` 开头。
- 相对路径以写出 module block 的目录为基准，而不是仓库根目录。
- 模块输入由调用方提供，模块输出供团队配置继续消费。

## 最小代码（Lab 91）

```hcl
# teams/team-a/main.tf
module "ec2" {
  source        = "../../modules/ec2"
  instance_name = "team-a-web"
  environment   = "dev"
}
```

## 核心知识（Lab 92：Custom Module 去硬编码）

- AMI、规格等业务参数应成为 module variables，由不同调用方覆盖。
- Child module 声明 `required_providers`，但 region、profile、凭据通常由 root provider 配置。
- 可复用模块不应在内部写死 provider block 或环境 region。

## 最小代码（Lab 92）

```hcl
# child module
variable "ami_id" { type = string }
variable "instance_type" { type = string }

resource "terraform_data" "instance" {
  input = {
    ami_id        = var.ami_id
    instance_type = var.instance_type
  }
}
```

## 核心知识（Lab 93：Module Variables 与避免硬编码）

- Variable 定义模块契约，类型和 validation 可把错误挡在模块边界。
- 同一个模块可被多次调用，每个调用传入不同配置。
- 合理默认值适合可选行为，关键业务标识应要求调用方显式传入。

## 最小代码（Lab 93）

```hcl
variable "instance_type" {
  type = string
}

module "team_one" {
  source        = "./modules/ec2"
  instance_type = "t2.micro"
}

module "team_two" {
  source        = "./modules/ec2"
  instance_type = "m5.large"
}
```

## 核心知识（Lab 94：由调用方覆盖 Module 输入）

- Module 内部使用 `var.*`，root module 通过参数决定最终值。
- Output 可返回有效配置，便于测试调用方覆盖是否生效。
- Region 若只是教学模型可作为变量；真实 AWS provider region 通常仍应由调用方 provider 管理。

## 最小代码（Lab 94）

```hcl
module "team_app" {
  source        = "./modules/ec2"
  ami           = "ami-0123456789abcdef0"
  instance_type = "t2.micro"
  region        = "ap-south-1"
}

output "effective_config" {
  value = module.team_app.instance_config
}
```

## 核心知识（Lab 95：Module 的 Provider 声明）

- `required_providers` 声明 child module 需要哪个插件、来源和兼容版本。
- `provider "aws"` 配置实例的 region、凭据等，应由 root module 持有。
- Child resource 自动使用调用方传入的默认 provider；alias 则需要额外声明和传递。

## 最小代码（Lab 95）

```hcl
# child module versions.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.5"
    }
  }
}

# root module
provider "aws" {
  region = var.aws_region
}
```

## 核心知识（Lab 96：Module Outputs 与跨资源引用）

- Child output 只暴露调用方真正需要的数据，形成低耦合接口。
- Root resource 引用 `module.ec2.instance_id` 时，Terraform 自动建立依赖。
- 不要输出完整资源对象来代替经过设计的稳定接口。

## 最小代码（Lab 96）

```hcl
# child
output "instance_id" {
  value = terraform_data.instance.output.id
}

# root
resource "terraform_data" "eip_association" {
  input = {
    instance_id = module.ec2.instance_id
    public_ip   = "203.0.113.96"
  }
}
```

## 核心知识（Lab 97：Root Module 与 Child Module）

- 当前执行 `terraform plan/apply` 的工作目录是 root module。
- 被 `module` block 调用的目录是 child module，不能自行成为同一次运行的 root。
- Root 负责组合、provider 和 backend；child 负责可复用业务能力。

## 最小代码（Lab 97）

```hcl
module "service_identity" {
  source       = "./modules/service_identity"
  service_name = "checkout-api"
  environment  = "dev"
}

output "service_full_name" {
  value = module.service_identity.service_full_name
}
```

## 核心知识（Lab 98：标准 Module Structure）

- 常见文件职责：`main.tf` 资源、`variables.tf` 输入、`outputs.tf` 输出、`versions.tf` 约束、`README.md` 文档。
- Terraform 按目录加载全部 `.tf`，文件名是组织方式而非执行顺序。
- 可用 `fileset()` 与集合运算检查模块是否缺少标准文件。

## 最小代码（Lab 98）

```hcl
locals {
  required = toset([
    "README.md", "main.tf", "variables.tf", "outputs.tf"
  ])
  actual  = toset(fileset("${path.module}/modules/ec2", "*"))
  missing = setsubtract(local.required, local.actual)
}
```

## 核心知识（Lab 99：Moved Block 迁移到 Module）

- 把 root resource 移入 child module 会改变完整 state 地址。
- `moved` 的目标必须包含 `module.<call>` 路径和模块内资源地址。
- 迁移后 plan 应显示地址移动而非销毁重建。

## 最小代码（Lab 99）

```hcl
module "s3_bucket" {
  source = "./modules/s3_bucket"
  bucket = local.legacy_bucket_name
}

moved {
  from = terraform_data.legacy_bucket
  to   = module.s3_bucket.terraform_data.bucket
}
```

## 核心知识（Lab 100：子模块中的多 Provider 配置）

- Root 可定义默认 `aws` 和 alias `aws.prod` 等多个 provider 实例。
- Child 若使用 alias，必须在 `configuration_aliases` 中声明。
- Root 通过 module 的 `providers` map 显式传入；child resource 再用 `provider = aws.prod` 选择。

## 最小代码（Lab 100）

```hcl
# child versions.tf
terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.prod]
    }
  }
}

# root
module "buckets" {
  source = "./modules/buckets"
  providers = {
    aws      = aws
    aws.prod = aws.prod
  }
}
```

## 核心知识（Lab 101：重命名带 `count` 的资源）

- `count` 实例地址包含索引；重命名 resource label 会改变全部实例地址。
- 整体 `moved` 可把旧资源集合迁移到结构相同的新资源集合。
- 名称、count 数量和实例语义保持一致时，plan 不应重新创建远端对象。

## 最小代码（Lab 101）

```hcl
resource "aws_s3_bucket" "renamed" {
  count  = 2
  bucket = "tf-pro-lab-101-${count.index}"
}

moved {
  from = aws_s3_bucket.original
  to   = aws_s3_bucket.renamed
}
```

## 核心知识（Lab 102：已有资源启用 `count`）

- 无索引资源改为 `count` 后，每个旧地址必须映射到正确的新索引。
- 映射顺序应按真实对象身份决定，不能只凭资源声明顺序猜测。
- 重构前后远端参数保持一致，才能得到纯 state 地址迁移。

## 最小代码（Lab 102）

```hcl
resource "aws_s3_bucket" "instances" {
  count  = 2
  bucket = "tf-pro-lab-102-${count.index}"
}

moved {
  from = aws_s3_bucket.a
  to   = aws_s3_bucket.instances[0]
}
moved {
  from = aws_s3_bucket.b
  to   = aws_s3_bucket.instances[1]
}
```

## 核心知识（Lab 103：已有资源启用 `for_each`）

- `for_each` key 成为 state 地址的一部分，应选择长期稳定的业务标识。
- 每个旧独立地址映射到明确的新 key 地址。
- 将 key 改名本身也是地址迁移，需要新的 `moved` 声明。

## 最小代码（Lab 103）

```hcl
resource "aws_s3_bucket" "instances" {
  for_each = {
    app  = "tf-pro-lab-103-a"
    logs = "tf-pro-lab-103-b"
  }
  bucket = each.value
}

moved {
  from = aws_s3_bucket.a
  to   = aws_s3_bucket.instances["app"]
}
moved {
  from = aws_s3_bucket.b
  to   = aws_s3_bucket.instances["logs"]
}
```

## 核心知识（Lab 104：Child Module 资源启用 `count`）

- 模块内地址必须包含完整 `module.<name>.resource` 路径。
- Child 中单资源变为 count 集合后，root 的 `moved` 可指向指定实例索引。
- 模块输入控制数量，output 可用 splat 汇总实例属性。

## 最小代码（Lab 104）

```hcl
module "buckets" {
  source       = "./modules/buckets"
  bucket_count = 3
}

moved {
  from = module.buckets.aws_s3_bucket.this
  to   = module.buckets.aws_s3_bucket.this[1]
}
```

## 核心知识（Lab 105：Root 资源拆分到 Child Modules）

- 资源移入模块后，地址增加 module 路径，但真实对象可以保持不变。
- 每个迁移资源都需要独立、准确的 `moved`。
- Root 通过 module outputs 继续消费 DynamoDB、S3 等资源属性。

## 最小代码（Lab 105）

```hcl
module "database" { source = "./modules/database" }
module "storage" { source = "./modules/storage" }

moved {
  from = aws_dynamodb_table.platform
  to   = module.database.aws_dynamodb_table.platform
}
moved {
  from = aws_s3_bucket.audit
  to   = module.storage.aws_s3_bucket.audit
}
```

## 核心知识（Lab 106：AWS CLI Shared Config 与 Credentials）

- AWS CLI config 保存 region、output、role 等配置；credentials 文件保存访问凭据。
- Config 中 named profile 写作 `[profile lab]`，credentials 中写作 `[lab]`。
- 可用 `AWS_CONFIG_FILE`、`AWS_SHARED_CREDENTIALS_FILE` 隔离实验文件，避免读取真实用户配置。

## 最小代码（Lab 106）

```ini
# config
[profile lab]
region = us-east-1
output = json

# credentials
[lab]
aws_access_key_id = test
aws_secret_access_key = test
```

## 核心知识（Lab 107：AWS Provider 读取 Shared Files）

- Provider 的 `shared_config_files` 和 `shared_credentials_files` 指定读取位置。
- `profile` 选择这些文件中的命名配置。
- Resource 不应包含 access key；认证属于 provider 配置与运行环境。

## 最小代码（Lab 107）

```hcl
provider "aws" {
  region                   = "us-east-1"
  profile                  = "lab"
  shared_config_files      = ["${path.module}/aws-config/config"]
  shared_credentials_files = ["${path.module}/aws-config/credentials"]
}
```

## 核心知识（Lab 108：AWS CLI Named Profile）

- `AWS_PROFILE` 为未显式指定 profile 的命令选择默认 named profile。
- 命令行 `--profile` 优先于 `AWS_PROFILE`。
- Config 与 credentials 中同名 profile 的 section 写法不同。

## 最小代码（Lab 108）

```bash
export AWS_PROFILE=audit
aws sts get-caller-identity
aws --profile lab sts get-caller-identity
```

## 核心知识（Lab 109：AWS Provider 选择 Named Profile）

- `profile = "audit"` 让 AWS provider 从共享文件选择 audit 配置。
- Provider 未写 region 时，可从该 profile 的 config 读取。
- 环境变量可能覆盖 profile region，排障时应同时检查运行环境。

## 最小代码（Lab 109）

```hcl
provider "aws" {
  profile                  = "audit"
  shared_config_files      = ["${path.module}/aws-config/config"]
  shared_credentials_files = ["${path.module}/aws-config/credentials"]
}

data "aws_region" "current" {}
```

## 核心知识（Lab 110：多个 Provider Alias）

- 无 alias 的同类型 provider 是默认实例。
- Resource 或 data source 用 `provider = aws.usa` 显式选择 alias。
- Alias 适用于同一次配置中的跨 region、账号、角色或 endpoint 操作。

## 最小代码（Lab 110）

```hcl
provider "aws" {
  region = "ap-southeast-1"
}
provider "aws" {
  alias  = "usa"
  region = "us-east-1"
}

resource "aws_s3_bucket" "usa" {
  provider = aws.usa
  bucket   = "tf-pro-lab-110-usa"
}
```

## 核心知识（Lab 111：AWS Provider `default_tags`）

- `default_tags` 自动合并到该 provider 管理且支持标签的资源。
- Resource 同名 tag 覆盖 provider 默认值。
- `tags` 是资源显式配置，`tags_all` 是合并后的最终结果。

## 最小代码（Lab 111）

```hcl
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Environment = "lab"
      Team        = "platform"
    }
  }
}

resource "aws_s3_bucket" "override" {
  bucket = "example"
  tags   = { Team = "network" }
}
```

## 核心知识（Lab 112：AWS Provider `assume_role`）

- Provider 先用来源凭据调用 STS AssumeRole，再使用临时身份操作资源。
- `role_arn` 标识目标角色，`session_name` 标识会话，便于审计。
- 真实跨账号访问还要求来源权限与目标 role trust policy 同时允许。

## 最小代码（Lab 112）

```hcl
provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn     = "arn:aws:iam::123456789012:role/deployer"
    session_name = "terraform-deploy"
  }
}
```

## 核心知识（Lab 113：比较基础身份与 AssumeRole 身份）

- 默认 provider 可代表来源身份，alias provider 可代表 assumed role 身份。
- 为 `aws_caller_identity` 绑定不同 provider，可验证实际 ARN 是否变化。
- 只有显式选择 alias 的资源才使用 assumed identity。

## 最小代码（Lab 113）

```hcl
data "aws_caller_identity" "base" {}
data "aws_caller_identity" "assumed" {
  provider = aws.assumed
}

resource "aws_s3_bucket" "assumed" {
  provider = aws.assumed
  bucket   = "tf-pro-lab-113"
}
```

## 核心知识（Lab 114：Dependency Lock File）

- 配置中的 version constraint 定义允许范围；`.terraform.lock.hcl` 记录实际选择。
- 普通 `init` 优先复用锁定版本，`init -upgrade` 在约束范围内重新选择。
- `hashes` 校验 provider 包；锁文件由 Terraform 维护，真实项目通常应提交。

## 最小代码（Lab 114）

```hcl
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "= 2.5.3"
    }
  }
}
```

```bash
terraform init -upgrade -input=false
```

## 核心知识（Lab 115：`TF_LOG` 与 `TF_LOG_PATH`）

- `TF_LOG` 开启日志，常见级别从 ERROR 到 TRACE；TRACE 最详细。
- `TF_LOG_PATH` 只指定文件位置，单独设置不会启用日志。
- 日志会追加且可能含敏感数据，复现前清旧文件，结束后清环境变量。

## 最小代码（Lab 115）

```powershell
$env:TF_LOG = "TRACE"
$env:TF_LOG_PATH = "terraform-trace.log"
terraform plan -input=false -no-color
Remove-Item Env:TF_LOG
Remove-Item Env:TF_LOG_PATH
```

## 核心知识（Lab 116：日志去向与会话生命周期）

- 只设置 `TF_LOG` 时详细日志写到 stderr，与正常输出同时显示。
- 再设置 `TF_LOG_PATH` 后，详细日志写入文件。
- 进程级环境变量只影响当前 shell 及其子进程；清除后后续命令不再追加日志。

## 最小代码（Lab 116）

```bash
export TF_LOG=INFO
terraform plan -no-color

export TF_LOG=TRACE
export TF_LOG_PATH=terraform-debug.log
terraform plan -no-color

unset TF_LOG TF_LOG_PATH
```

## 核心知识（Lab 117：HCP Terraform 概览）

- HCP Terraform 提供远程运行、state、变量、权限、审计和私有 registry 等协作能力，不替代 Terraform 语言。
- HCP workspace 管理一套配置、state 和 runs；它不同于 CLI workspace。
- 配置可来自 VCS、CLI 或 API；受治理 run 可加入成本、策略和审批阶段。

## 最小代码（Lab 117）

```hcl
terraform {
  cloud {
    organization = "example-org"
    workspaces {
      name = "network-dev"
    }
  }
}
```

## 核心知识（Lab 118：HCP Terraform 定价判断）

- HCP Terraform 是托管服务；Terraform Enterprise 面向自托管与强隔离场景。
- 本 Lab 的核心是理解计费与受管资源规模相关，而不是按 `plan/apply` 命令次数简单计数。
- 套餐名、价格、免费额度和功能矩阵会变化，预算时必须核对当时官方页面。

## 最小代码（Lab 118）

```hcl
locals {
  delivery_model = {
    hcp_terraform        = "managed_saas"
    terraform_enterprise = "self_hosted"
  }

  pricing_rule = "verify current official pricing; do not hard-code course screenshots"
}
```

## 核心知识（Lab 119：账号、Organization 与安全边界）

- 创建 HCP 账号或 Organization 不会自动创建 workspace、迁移 state 或配置云凭据。
- 用户 token、team token 和组织级凭据应遵循最小权限、短有效期与可撤销原则。
- 密码、token 和邮箱验证链接都属于敏感信息，不能写入配置、output 或截图。

## 最小代码（Lab 119）

```bash
terraform login
# 凭据由 CLI 安全存储；不要把 token 写入 *.tf 或 Git。
terraform logout
```

## 核心知识（Lab 120：Organization、Project 与 Workspace）

- Organization 是成员、团队和组织设置边界。
- Project 对 workspaces 进行分组并帮助划分访问范围。
- Workspace 管理具体配置的变量、state、runs 和执行设置；dev/prod 应使用独立边界。

## 最小代码（Lab 120）

```text
organization
├── network-project
│   ├── network-dev workspace
│   └── network-prod workspace
└── app-project
    ├── app-dev workspace
    └── app-prod workspace
```

## 核心知识（Lab 121：创建 Workspace 与选择 Workflow）

- 创建 workspace 时要明确 project、配置来源、Terraform 版本、execution mode 和 workflow。
- VCS-driven、CLI-driven、API-driven 适用于不同配置交付方式。
- Workspace 创建后仍需配置变量、云认证、团队权限、策略和 apply 方式。

## 最小代码（Lab 121）

```hcl
terraform {
  cloud {
    organization = "example-org"
    workspaces {
      name = "payments-prod"
    }
  }
}
```

## 核心知识（Lab 122：VCS Workspace 与安全认证）

- VCS workspace 需配置 repository、branch、working directory 和触发路径。
- Pull request 通常触发 speculative plan；目标分支 push 触发标准 run。
- 云认证优先使用动态短期凭据，并将角色权限限制到 project/workspace 所需范围。

## 最小代码（Lab 122）

```text
pull request  -> speculative plan
branch push  -> standard plan
manual apply -> authorized confirmation
discard      -> stop without infrastructure changes
```

## 核心知识（Lab 123：CLI-driven Workflow）

- `cloud` block 关联本地目录与 HCP organization/workspace。
- 本地 `plan/apply/destroy` 上传配置并触发远端 run，日志回流终端。
- HCP token 认证 Terraform CLI；云 provider 认证是另一套凭据。

## 最小代码（Lab 123）

```bash
terraform login
terraform init
terraform plan
terraform apply
```

## 核心知识（Lab 124：CLI-driven 步骤与故障定位）

- 正确顺序是配置 cloud target、登录、初始化，再执行远端 plan/apply。
- 远端 run URL、workspace history 和 execution mode 是确认执行位置的直接证据。
- 不提交 `credentials.tfrc.json`，也不要把 token 放进变量默认值。

## 最小代码（Lab 124）

```bash
terraform login app.terraform.io
terraform init -input=false
terraform plan -input=false
terraform apply
```

## 核心知识（Lab 125：HCP Terraform Variable Sets）

- Terraform variable 为 `var.<name>` 提供输入；environment variable 注入运行进程。
- Variable set 可复用于多个 project/workspace，workspace 同名变量具有更具体的覆盖层级。
- Sensitive 只限制平台再次显示，不保证值不会进入 state 或调试日志。

## 最小代码（Lab 125）

```hcl
variable "region" {
  type = string
}

provider "aws" {
  region = var.region
}
```

```text
Terraform variable: region = "us-east-1"
Environment variable: TF_LOG = "WARN"
```

## 核心知识（Lab 126：Sentinel Policy as Code）

- Sentinel 在 Terraform plan 之外实施组织治理策略。
- Advisory 只告警；soft-mandatory 需要授权覆盖；hard-mandatory 不能在当前 run 覆盖。
- Policy set 可按组织、project、workspace 或标签范围应用，并应通过 VCS 审查版本。

## 最小代码（Lab 126）

```sentinel
import "tfplan/v2" as tfplan

main = rule {
  length(tfplan.resource_changes) <= 20
}
```

## 核心知识（Lab 127：Run Triggers 与 Workspace 输出依赖）

- `terraform_remote_state` 或 `tfe_outputs` 负责读取上游 root outputs。
- Run trigger 负责在上游成功 apply 后为下游排队新 run；它不传递数据本身。
- Source 是上游，target/dependent 是下游；配置时需要相应 workspace 权限。

## 最小代码（Lab 127）

```hcl
data "tfe_outputs" "network" {
  organization = "example-org"
  workspace    = "network-prod"
}

locals {
  vpc_id = data.tfe_outputs.network.values.vpc_id
}
```

## 核心知识（Lab 128：HCP Terraform Teams 与最小权限）

- 用户通过 Team 获得组织、project 或 workspace 级权限。
- 多个授权会叠加，低权限 Team 不会撤销另一个 Team 的高权限。
- Owners 权限最大，成员应极少；自动化身份应使用职责明确的最小权限 team token。

## 最小代码（Lab 128）

```hcl
locals {
  team_design = {
    developers = "project-scoped plan/write as required"
    auditors   = "workspace-scoped read"
    automation = "least-privilege team token"
    owners     = "small emergency/admin group"
  }
}
```

## 核心知识（Lab 129：Workspace Permissions）

- 预设权限递增为 Read、Plan、Write、Admin。
- Plan 能发起计划但不能 apply；Write 可日常 plan/apply；Admin 还能改设置与访问。
- Custom role 可细分 runs、variables、state、Sentinel mock 和 run task 权限，但不包含 Admin-only 能力。

## 最小代码（Lab 129）

```hcl
locals {
  workspace_roles = {
    read  = "view runs and permitted data"
    plan  = "read plus create plans"
    write = "plan and apply"
    admin = "settings, access and destructive administration"
  }
}
```

## 核心知识（Lab 130：HCP Terraform Health Assessments）

- Drift Detection 比较真实基础设施与配置；Continuous Validation 持续评估自定义条件。
- Assessment 是非修复性检查，不会自动改资源、state 或配置。
- `check` 适合 post-apply 监控；发现 drift 后仍需人工决定恢复配置还是接受并更新代码。

## 最小代码（Lab 130）

```hcl
data "http" "health" {
  url = "https://example.com/health"
}

check "service_health" {
  assert {
    condition     = data.http.health.status_code == 200
    error_message = "服务健康检查失败。"
  }
}
```

## 核心知识（Lab 131：迁移 Local State 到 HCP Terraform）

- State migration 只改变同一批对象的 state 存储位置，不应重建或重新 import。
- 迁移前冻结写入并制作受保护备份；配置 cloud target 后用 `init` 执行迁移。
- 迁移后先验证远端 state 和无重建 plan，再清理遗留本地 state；变量与 provider 凭据不会自动迁移。

## 最小代码（Lab 131）

```hcl
terraform {
  cloud {
    organization = "example-org"
    workspaces {
      name = "network-prod"
    }
  }
}
```

```bash
terraform login
terraform init -migrate-state
terraform plan
```

## 核心知识（Lab 132：`aws_caller_identity`）

- `aws_caller_identity` 返回当前 provider 调用身份的 account ID、user ID 和 ARN。
- 它适合动态拼接账号相关 ARN、验证 profile/assume role 是否生效。
- 查询成功只证明身份可用，不证明 IAM policy、SCP 或 permission boundary 允许具体业务操作。

## 最小代码（Lab 132）

```hcl
data "aws_caller_identity" "current" {}

locals {
  role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/deployer"
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}
```

## 核心知识（Lab 133：`aws_subnets` 与 `aws_subnet`）

- `aws_subnets` 用 filters 返回多个 subnet ID；`aws_subnet` 读取单个 subnet 的详细属性。
- 多个 filter 取交集，可使用 `vpc-id`、可用区或 `tag:*`。
- 查询刚创建的多个 subnet 时，需要确保读取发生在创建之后。

## 最小代码（Lab 133）

```hcl
data "aws_subnets" "lab" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.lab.id]
  }
  depends_on = [aws_subnet.a, aws_subnet.b]
}

data "aws_subnet" "first" {
  id = aws_subnet.a.id
}
```

## 核心知识（Lab 134：IAM 用户、Login Profile 与 Access Key）

- IAM user、控制台 login profile 和 access key 是三个独立资源。
- Login profile 可要求首次登录改密；access key secret 只在创建时可取得。
- 即使 output 标记 sensitive，密码和 secret 仍会进入 state；长期生产认证应优先使用短期身份。

## 最小代码（Lab 134）

```hcl
resource "aws_iam_user" "operator" {
  name = "tf-pro-lab-134-operator"
}

resource "aws_iam_user_login_profile" "operator" {
  user                    = aws_iam_user.operator.name
  password_length         = 20
  password_reset_required = true
}

resource "aws_iam_access_key" "operator" {
  user = aws_iam_user.operator.name
}

output "secret" {
  value     = aws_iam_access_key.operator.secret
  sensitive = true
}
```

## 核心知识（Lab 134.5：企业 IAM 认证方式）

- Human 优先通过企业 SSO / IAM Identity Center 登录并获得 permission set 对应角色。
- Workload 和跨账号部署使用 IAM Role + AssumeRole；CI/CD 优先使用 OIDC 换取短期凭据。
- 短期凭据包含 session token 和 expiration，降低长期 access key 泄露风险。

## 最小代码（Lab 134.5）

```text
Human: SSO -> Permission Set -> IAM Role -> Terraform
CI/CD: OIDC -> IAM OIDC Provider -> Deploy Role -> Terraform
Cross-account: Source Identity -> AssumeRole -> Target Role
```

## 核心知识（Lab 135：Managed、Inline Policy 与用户绑定）

- Customer managed policy 是可复用对象，需要 attachment 绑定到 user/role/group。
- Inline policy 只属于一个主体，生命周期与该主体紧密耦合。
- S3 bucket action 使用 bucket ARN，对象 action 使用 `bucket/*`；最终授权仍受显式 Deny、SCP 等影响。

## 最小代码（Lab 135）

```hcl
resource "aws_iam_policy" "s3_read" {
  name = "s3-read"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject"]
      Resource = ["arn:aws:s3:::shared/*"]
    }]
  })
}

resource "aws_iam_user_policy_attachment" "reader" {
  user       = aws_iam_user.reader.name
  policy_arn = aws_iam_policy.s3_read.arn
}
```

## 核心知识（Lab 136：`aws_iam_policy_document`）

- Data source 用结构化 HCL 生成规范 IAM JSON，减少手工字符串错误。
- `.json` 可直接传给 IAM resource；`jsondecode()` 便于按语义测试。
- Statement 中 action 与 resource 必须按 AWS 授权模型精确配对。

## 最小代码（Lab 136）

```hcl
data "aws_iam_policy_document" "read_logs" {
  statement {
    sid       = "DescribeLogGroups"
    actions   = ["logs:DescribeLogGroups"]
    resources = ["*"]
  }
  statement {
    sid       = "ReadLogStream"
    actions   = ["logs:GetLogEvents"]
    resources = [local.log_stream_arn]
  }
}

resource "aws_iam_policy" "read_logs" {
  name   = "read-logs"
  policy = data.aws_iam_policy_document.read_logs.json
}
```

## 核心知识（Lab 137：IAM Role 与 Trust Policy）

- Role trust policy 决定谁能调用 `sts:AssumeRole`，不授予业务 API 权限。
- Service principal 如 `ec2.amazonaws.com` 表示 AWS 服务可扮演角色。
- Role permissions、`iam:PassRole` 和 trust policy 是不同授权环节。

## 最小代码（Lab 137）

```hcl
data "aws_iam_policy_document" "ec2_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2" {
  name               = "ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
}
```

## 核心知识（Lab 138：IAM Role Policy Attachment）

- `aws_iam_role_policy_attachment` 管理一个 role 与一个 managed policy 的关系。
- Trust policy 解决“谁能成为该角色”，permissions policy 解决“成为角色后能做什么”。
- 不要混用不同 attachment 资源共同争抢同一附件集合。

## 最小代码（Lab 138）

```hcl
resource "aws_iam_policy" "logs" {
  name   = "create-log-group"
  policy = data.aws_iam_policy_document.logs.json
}

resource "aws_iam_role_policy_attachment" "logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.logs.arn
}
```

## 核心知识（Lab 139：EC2 Launch Template）

- Launch template 保存未来实例使用的 AMI、规格、网络和其他启动参数，本身不启动 EC2。
- Template 自身 tags 与 `tag_specifications` 中未来实例 tags 相互独立。
- 引用 security group ID 会建立依赖，template 版本随配置更新。

## 最小代码（Lab 139）

```hcl
resource "aws_launch_template" "web" {
  name                   = "tf-pro-lab-139-web"
  image_id               = "ami-12345678"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]

  tags = { Name = "tf-pro-lab-139-template" }
  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "tf-pro-lab-139-instance" }
  }
}
```

## 核心知识（Lab 140：Auto Scaling Group 与 Launch Template）

- ASG 核心输入包括 min、desired、max、subnet 集合和 launch template 版本。
- 容量必须满足 `min <= desired <= max`，subnet 应跨所需可用区且互不重复。
- 本 Lab 用本地模型验证配置关系，不宣称 LocalStack 已执行真实扩缩容。

## 最小代码（Lab 140）

```hcl
locals {
  asg_spec = {
    min_size            = 1
    desired_capacity    = 2
    max_size            = 3
    vpc_zone_identifier = sort([aws_subnet.a.id, aws_subnet.b.id])
    launch_template = {
      id      = aws_launch_template.web.id
      version = "$Latest"
    }
    health_check_type = "EC2"
  }
}
```

## 核心知识（Lab 141：S3 Bucket Policy）

- Bucket policy 是绑定到 bucket 的 resource-based policy。
- `s3:ListBucket` 使用 bucket ARN；`s3:GetObject` 使用 `bucket/*`。
- Principal 应精确到可信账号或角色，避免不必要的通配符。

## 最小代码（Lab 141）

```hcl
data "aws_iam_policy_document" "logs" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.logs.arn]
    principals {
      type        = "AWS"
      identifiers = [var.reader_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.logs.json
}
```

## 核心知识（Lab 142：AWS CLI `source_profile`）

- Role profile 的 `source_profile` 指定哪组来源凭据用于尝试 AssumeRole。
- Config 中写 `[profile lab-142]`；credentials 只需为来源 profile 写 `[base]`。
- 解析配置不等于 AssumeRole 一定成功；还需要来源权限、目标 trust policy 和可达 STS。

## 最小代码（Lab 142）

```ini
# config
[profile base]
region = us-east-1

[profile lab-142]
role_arn = arn:aws:iam::000000000000:role/demo
source_profile = base

# credentials
[base]
aws_access_key_id = test
aws_secret_access_key = test
```

## 核心知识（Lab 143：Terraform Professional 蓝图建模）

- 本地 JSON 可把考试 domain、课程 section 和文件格式建模为结构化数据。
- `for ... if` 区分 lab-based 与 MCQ domain，map 推导建立编号索引。
- 考试政策可能变化；该 Lab 训练数据转换，不代表实时官方规则。

## 最小代码（Lab 143）

```hcl
locals {
  blueprint = jsondecode(file("${path.module}/data/blueprint.json"))
  lab_domains = [
    for domain in local.blueprint.domains : domain.title
    if domain.assessment_style == "lab"
  ]
  sections_by_number = {
    for section in local.blueprint.sections :
    tostring(section.number) => section.title
  }
}
```

## 核心知识（Lab 144：考试预约规则建模）

- `jsondecode(file())` 将证件、系统、空间和行为规则转换为 Terraform object。
- `for` 可把风险控制 map 转换为易读标签。
- 规则数据应来自单一输入源，避免在 outputs 中重复硬编码。

## 最小代码（Lab 144）

```hcl
locals {
  rules = jsondecode(file("${path.module}/data/exam-rules.json"))
  risk_labels = [
    for risk, action in local.rules.risk_controls :
    "${risk}: ${action}"
  ]
}
```

## 核心知识（Lab 145：考试预约流程建模）

- `one()` 适合断言筛选结果恰好一项，零项或多项都会失败。
- `for ... if` 筛选附加时间 accommodation，并由输入数据计算总时长。
- 流程步骤可按顺序保留为 list，也可按 order 转换成 map。

## 最小代码（Lab 145）

```hcl
locals {
  data = jsondecode(file("${path.module}/data/booking.json"))
  professional = one([
    for exam in local.data.exams : exam
    if exam.level == "professional"
  ])
  extra_minutes = sum([
    for item in local.data.accommodations : item.extra_minutes
    if item.extra_minutes > 0
  ])
  total_minutes = local.professional.duration_minutes + local.extra_minutes
}
```

## 核心知识（Lab 146：考试环境导航建模）

- `contains()` 可判断每个场景是否提供 VS Code、CLI 或 validation 链接。
- List 过滤区分考试阶段、lab 场景和允许/禁止资源。
- 时间预算应从总时长与比例数据计算，而不是手写结果。

## 最小代码（Lab 146）

```hcl
locals {
  exam = jsondecode(file("${path.module}/data/environment.json"))
  labs = [
    for stage in local.exam.stages : stage if stage.type == "lab"
  ]
  navigation = {
    for scenario in local.exam.scenarios : scenario.id => {
      has_cli    = contains(scenario.links, "cli")
      has_vscode = contains(scenario.links, "vscode")
    }
  }
}
```

## 核心知识（Lab 147：Professional Exam 实战策略）

- 修改前备份场景，先按任务依赖和耗时做 triage。
- 熟悉官方文档导航、验证命令和远端 state 示例位置。
- 考试环境的临时凭据策略不能照搬到生产；真实工程仍应使用安全身份链。

## 最小代码（Lab 147）

```text
1. 备份 scenarios
2. 阅读全部场景与 validation command
3. 先做独立、短、确定的任务
4. 每完成一步立即 fmt / validate / plan
5. 最后运行题目 validation 并复查所有场景
```

## 核心知识（Lab 148：高频场景速查）

- 高频主题包括 module/state 重构、provider alias、data source filters、import 与生成配置。
- `contains()`、`for ... if` 可从 mock 题库筛选相应技能。
- Import ID、资源地址和 generated config 冲突项应按资源类型分别记忆与验证。

## 最小代码（Lab 148）

```hcl
locals {
  topics = jsondecode(file("${path.module}/data/topics.json")).topics
  module_refactors = [
    for topic in local.topics : topic.id
    if topic.category == "modules"
    && contains(topic.skills, "moved_block")
  ]
  filtered_data_sources = [
    for source in local.data_sources : source.name
    if source.requires_filters
  ]
}
```

## 核心知识（Lab 149：Professional MCQ 重点）

- 重点关系包括 HCP 层级、variable precedence、Sentinel、run trigger/task 和 saved plan。
- Workspace variable 与 variable set 同名时，更具体的 workspace 值覆盖共享值。
- Vault secret 可进入 state；`check` 失败是非阻断警告；saved plan 应由 `apply <planfile>` 执行。

## 最小代码（Lab 149）

```bash
terraform plan -out=ec2.plan
terraform apply ec2.plan
```

```hcl
locals {
  effective_capacity = coalesce(
    try(local.workspace_variables.db_capacity, null),
    local.variable_set.db_capacity
  )
}
```

## 核心知识（Lab 150：Terraform 综合挑战训练方法）

- 先完整读题并拆分任务，再定位资源地址、输入、输出和 state 变化。
- 每完成一个小步骤就运行 fmt、validate 和 plan，避免错误累积。
- 以官方文档和题目 validation 为准，结束时确认资源可安全销毁。

## 最小代码（Lab 150）

```bash
terraform fmt -recursive
terraform validate
terraform plan -input=false -no-color -out=tfplan
terraform apply -auto-approve tfplan
terraform output
terraform destroy -auto-approve
```

## 核心知识（Lab 152：获取挑战仓库与启动练习）

- Clone 后先确认目标 challenge 与工作目录，不要在参考实现上直接修改。
- 检查 Terraform 版本、provider 初始化和题目附带 validation 命令。
- 创建自己的备份或分支，确保可快速回到初始状态。

## 最小代码（Lab 152）

```bash
git clone <challenge-repository>
cd <challenge-repository>/<challenge>
terraform version
terraform init -input=false
terraform validate
```

## 核心知识（Lab 153：挑战一概览）

- 挑战一组合配置修复、资源 import、outputs 和 state 操作。
- Import 前要同时确认真实 ID 与 Terraform 目标地址。
- 长题应按“修配置 → 导入 → 无意外 plan → 输出 → state 维护”顺序逐步验证。

## 最小代码（Lab 153）

```text
1. terraform fmt / validate
2. 修复 provider 与 resource 配置
3. import 已存在对象
4. terraform plan 检查 drift
5. 添加并验证 outputs
6. 使用 state CLI 完成地址维护
7. destroy / cleanup
```

## 核心知识（Lab 154：挑战一解法一）

- 修复 provider/resource 后，通过 data source 或资源引用输出 bucket、IAM user 和安全组信息。
- 不要把动态 ID 写死；output 应引用真实资源或查询结果。
- 在 LocalStack 验证 API 闭环不代表真实 AWS 权限与网络行为完全相同。

## 最小代码（Lab 154）

```hcl
data "aws_s3_buckets" "all" {}
data "aws_iam_users" "all" {}

output "s3_buckets" {
  value = data.aws_s3_buckets.all.names
}
output "user_names" {
  value = data.aws_iam_users.all.names
}
output "sg_id" {
  value = aws_security_group.challenge.id
}
```

## 核心知识（Lab 155：把 Output 保存到文件与 State 操作）

- `local_file` 可把 Terraform 表达式渲染为文本或 JSON 制品。
- 使用 `jsonencode` 生成结构化文件，避免手工拼接。
- `state list/show/mv/rm` 分别用于查看、迁移和解除管理；`state rm` 不删除真实对象。

## 最小代码（Lab 155）

```hcl
resource "local_file" "inventory" {
  filename = "output/inventory.json"
  content = jsonencode({
    buckets = var.bucket_names
    users   = var.user_names
  })
}

output "artifact_files" {
  value = [local_file.inventory.filename]
}
```

```bash
terraform state list
terraform state show local_file.inventory
```

## 核心知识（Lab 156：S3 Object 与 State 清理）

- `aws_s3_object` 依赖 bucket ID，并独立管理 object key 与内容。
- 删除配置、`state rm` 和 `destroy` 的语义不同：前者产生销毁计划，中者只移除 state，后者按依赖清理。
- 清理前先确认 object 是否应保留，以及 bucket 是否仍含其他数据。

## 最小代码（Lab 156）

```hcl
resource "aws_s3_bucket" "challenge" {
  bucket = "tf-pro-challenge-156"
}

resource "aws_s3_object" "report" {
  bucket  = aws_s3_bucket.challenge.id
  key     = "reports/result.txt"
  content = "challenge complete"
}
```

## 核心知识（Lab 157：挑战二模块重构概览）

- 模块重构同时涉及 source、输入、输出和 state 地址迁移。
- 先记录旧地址，再建立 child module，最后用 `moved` 或 `state mv` 对齐。
- 成功标准是 plan 不意外销毁并且 root 仍能通过 outputs 消费结果。

## 最小代码（Lab 157）

```text
old root resource
  -> child module resource
  -> moved block maps state address
  -> module output restores caller contract
  -> plan shows no replacement
```

## 核心知识（Lab 158：模块化 S3 与 IAM）

- S3 与 IAM 可按职责拆成独立 child modules。
- Root 传入业务名称，child 创建资源并输出最终名称。
- Provider 配置留在 root，child 只声明 provider requirement。

## 最小代码（Lab 158）

```hcl
module "bucket" {
  source      = "./modules/s3_bucket"
  bucket_name = "tf-pro-challenge-158"
}

module "operator" {
  source    = "./modules/iam_user"
  user_name = "tf-pro-challenge-158-operator"
}

output "bucket_name" { value = module.bucket.bucket_name }
output "operator_name" { value = module.operator.user_name }
```

## 核心知识（Lab 159：模块输出与 State 映射）

- 移入模块后，用 `moved` 将旧 root 地址指向模块内部地址。
- Root output 改为引用 module output，不应穿透模块直接读取内部资源。
- `refactor_map` 等说明性 output 可帮助验收，但真正安全性由 plan/state 地址证明。

## 最小代码（Lab 159）

```hcl
module "bucket" {
  source      = "./modules/s3_bucket"
  bucket_name = local.bucket_name
}

moved {
  from = aws_s3_bucket.this
  to   = module.bucket.aws_s3_bucket.this
}

output "bucket_name" {
  value = module.bucket.bucket_name
}
```

## 核心知识（Lab 160：AWS Provider 集成挑战概览）

- 先识别 provider 的 profile、alias、default tags、endpoint 与身份数据源。
- Resource 使用哪个 provider 是配置语义的一部分，尤其在跨账号/区域场景。
- 通过 caller identity 和 plan 验证实际身份，不凭配置名称猜测。

## 最小代码（Lab 160）

```text
shared profile -> provider configuration
provider alias -> selected resources/data sources
default_tags   -> final tags_all
caller_identity -> effective AWS principal
```

## 核心知识（Lab 161：Alias、Default Tags 与 Caller Identity）

- Alias provider 可代表另一 region/profile/role；resource 必须显式选择。
- `default_tags` 统一治理标签，resource 同名 key 可覆盖。
- 为每个 provider 查询 caller identity，可验证实际账号与 ARN。

## 最小代码（Lab 161）

```hcl
provider "aws" {
  alias  = "audit"
  region = "us-east-1"
  default_tags {
    tags = { ManagedBy = "Terraform", Challenge = "3" }
  }
}

data "aws_caller_identity" "audit" {
  provider = aws.audit
}

resource "aws_s3_bucket" "audit" {
  provider = aws.audit
  bucket   = "tf-pro-challenge-161"
}
```

## 核心知识（Lab 162：分阶段应用 Local 与 AWS 资源）

- Targeted apply 可在挑战中先创建本地依赖制品，但不是常规持续部署方式。
- 第一阶段完成后应运行完整 plan/apply，让配置最终收敛。
- Local provider 与 AWS provider 可在同一 root 中协作，引用关系决定依赖顺序。

## 最小代码（Lab 162）

```hcl
resource "local_file" "account" {
  filename = "output/account.txt"
  content  = data.aws_caller_identity.current.account_id
}

resource "aws_s3_object" "account" {
  bucket  = aws_s3_bucket.audit.id
  key     = "account.txt"
  content = local_file.account.content
}
```

```bash
terraform apply -target=local_file.account
terraform plan
terraform apply
```

## 核心知识（Lab 163：`count`、`for` 与 Output 挑战概览）

- CSV 输入先解码为 object list，再转换类型并驱动多个实例。
- `count.index` 适合按原列表创建；`for_each` 更适合稳定业务 key。
- Outputs 可生成 list、set、map 与 map of objects，且不应重复硬编码输入。

## 最小代码（Lab 163）

```text
CSV file
  -> csvdecode()
  -> normalize types
  -> count / for_each
  -> resource instances
  -> for expressions
  -> structured outputs
```

## 核心知识（Lab 164：`csvdecode` 驱动 EC2 配置）

- CSV 每行成为一个 object，字段初始均为 string。
- 可用 `count = length(local.specs)` 和 `count.index` 逐行建立模拟实例。
- 先归一化字段，再把同一份结构用于资源与 outputs。

## 最小代码（Lab 164）

```hcl
locals {
  instance_specs = csvdecode(file("${path.module}/ec2.csv"))
}

resource "terraform_data" "instance" {
  count = length(local.instance_specs)
  input = local.instance_specs[count.index]
}

output "instance_count" {
  value = length(terraform_data.instance)
}
```

## 核心知识（Lab 165：EC2 配置结构化 Output）

- Splat 或 `for` 从多个实例提取单字段 list。
- Map 推导可按实例 ID 或名称建立结构化索引。
- Output 应表达消费者需要的 contract，而不是泄露全部内部对象。

## 最小代码（Lab 165）

```hcl
output "instance_ids" {
  value = [for instance in terraform_data.instance : instance.output.instance_id]
}

output "instance_summary" {
  value = {
    for instance in terraform_data.instance :
    instance.output.name => {
      id     = instance.output.instance_id
      ami    = instance.output.ami_id
      region = instance.output.region
    }
  }
}
```

## 核心知识（Lab 166：创建 VPC 与 Subnet 基础）

- Subnet 通过 `vpc_id` 引用 VPC，Terraform 自动建立依赖。
- CIDR 不能重叠，并应位于 VPC CIDR 内；多可用区部署需设置相应 AZ。
- Outputs 暴露 VPC ID 与 subnet IDs，供后续安全模块消费。

## 最小代码（Lab 166）

```hcl
resource "aws_vpc" "this" {
  cidr_block = "10.166.0.0/16"
}

resource "aws_subnet" "app" {
  for_each = {
    a = { cidr = "10.166.1.0/24", az = "us-east-1a" }
    b = { cidr = "10.166.2.0/24", az = "us-east-1b" }
  }
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
}
```

## 核心知识（Lab 167：CSV 驱动安全组规则）

- 按 direction 筛选 ingress/egress，并将单端口或范围统一为数值边界。
- `for_each` key 应稳定且唯一，可组合 direction、protocol、port 和 CIDR。
- 新 AWS provider 资源可分别使用 ingress/egress rule 类型，降低整组规则耦合。

## 最小代码（Lab 167）

```hcl
locals {
  raw_rules = csvdecode(file("${path.module}/sg.csv"))
  ingress = {
    for i, rule in local.raw_rules : "${rule.protocol}-${rule.port}-${i}" => rule
    if rule.direction == "in"
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each          = local.ingress
  security_group_id = aws_security_group.this.id
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr
}
```

## 核心知识（Lab 168：模块重构 VPC / SG）

- Network module 输出 VPC ID，security module 通过输入消费它。
- 模块间引用自动建立依赖，root 负责组合而不是复制内部逻辑。
- 若旧资源已在 state，必须为 VPC、subnet 和 security group 分别迁移地址。

## 最小代码（Lab 168）

```hcl
module "network" {
  source = "./modules/network"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

moved {
  from = aws_vpc.this
  to   = module.network.aws_vpc.this
}
```

## 核心知识（Lab 169：Profile、`source_profile` 与 Provider Alias）

- 多个 role profile 可共享一个 base source profile，不必复制长期凭据。
- Provider alias 分别选择 read-only、IAM、EC2 等 profile。
- 真正 AssumeRole 仍需来源权限与目标 trust；LocalStack 只验证训练路径。

## 最小代码（Lab 169）

```hcl
provider "aws" {
  alias                    = "iam"
  profile                  = "iam-access"
  shared_config_files      = ["${path.module}/aws-config/config"]
  shared_credentials_files = ["${path.module}/aws-config/credentials"]
}

data "aws_caller_identity" "iam" {
  provider = aws.iam
}
```

## 核心知识（Lab 170：CSV 转换与多种 Output）

- 同一份 CSV 可派生 AMI list、唯一 team set、按名称索引的 map 和嵌套 map。
- `toset()` 去重但不表达业务顺序；展示稳定结果时可再 `sort(tolist(...))`。
- Map of maps 适合下游按 key 查询，list 适合保留输入顺序。

## 最小代码（Lab 170）

```hcl
locals {
  rows              = csvdecode(file("${path.module}/ec2.csv"))
  list_ami          = [for row in local.rows : row.ami_id]
  unique_team_names = toset([for row in local.rows : row.team_name])
  map_of_maps = {
    for row in local.rows : row.name => {
      id     = row.instance_id
      ami    = row.ami_id
      region = row.region
      team   = row.team_name
    }
  }
}
```

## 核心知识（Lab 171：Data Source 读取 Subnet 并生成规则）

- 先用 plural data source 找 IDs，再用 singular data source 读取各 subnet CIDR。
- CSV 中的 `cidr_key` 应通过查找 map 映射到实际 CIDR，避免硬编码。
- 规则生成前要过滤 direction、解析端口范围，并为 `for_each` 构造唯一 key。

## 最小代码（Lab 171）

```hcl
data "aws_subnets" "app" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.this.id]
  }
}

data "aws_subnet" "app" {
  for_each = toset(data.aws_subnets.app.ids)
  id       = each.value
}

locals {
  subnet_cidrs = [
    for subnet in data.aws_subnet.app : subnet.cidr_block
  ]
}
```
