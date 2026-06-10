# Terraform专业级课程环境需求分类
根据你提供的100+节课程内容，我将所有主题按**Docker本地环境可完成**、**必须使用AWS云环境**和**纯理论无需环境**三类进行了精准划分，同时标注了部分可本地练习但课程示例用AWS的主题。

## 一、完全可在Docker本地环境完成（无需任何云服务）
这部分占课程基础内容的约60%，核心是Terraform语言本身、CLI工具和本地配置，所有实操都可以在Docker容器内完成，推荐使用官方`hashicorp/terraform`镜像并预装Checkov、Vault等工具。

| 课程主题分类 | 对应视频编号（参考） | 核心内容 |
|--------------|----------------------|----------|
| Terraform CLI基础 | 5-8 | `init`/`plan`/`apply`命令及选项、`-input=false`（自动化必备）、`-no-color`标志 |
| 插件管理 | 9-12 | 插件缓存、文件系统镜像（离线安装Provider） |
| 静态代码分析 | 13-17 | Checkov安装、代码扫描vs计划扫描 |
| 计划与状态基础 | 16-18 | 计划保存到文件、TF_LOG调试环境变量 |
| Terraform语言核心 | 19-30 | 资源导入（基础概念，可用local资源练习）、资源targeting、`random`资源、`moved`块、字符串转义、Heredoc文档、`jsonencode`/`jsondecode` |
| 数据类型与表达式 | 50-65 | list/map/object/set数据类型、嵌套类型、`count`/`for_each`、条件表达式、`for`表达式、`csvdecode`、`flatten`/`distinct` |
| 模板功能 | 65-67 | `templatefile`函数、列表/地图与模板结合 |
| 代码验证与安全 | 36-43 | 输入变量验证、preconditions/postconditions、`check`块、`sensitive`参数 |
| 资源生命周期 | 45-49 | `lifecycle`元参数：`create_before_destroy`、`prevent_destroy`、`ignore_changes` |
| 模块基础 | 84-99 | 模块创建、引用、变量、输出、标准结构、根模块/子模块概念 |
| 本地后端与调试 | 72-73, 114-116 | 本地后端配置、依赖日志、`TF_LOG_PATH`调试 |
| 测试框架 | 80-83 | Terraform Test编写、断言、根级属性 |
| 密钥管理基础 | 43-44 | HashiCorp Vault基础（Vault可通过Docker本地运行）、Vault Provider |

## 二、必须使用AWS云环境（需要AWS账号与权限）
这部分占课程实操内容的约35%，核心是AWS Provider集成和AWS资源管理，所有实操都需要调用AWS API，无法在本地模拟。

| 课程主题分类 | 对应视频编号（参考） | 核心内容 |
|--------------|----------------------|----------|
| AWS Provider高级配置 | 106-113 | AWS CLI配置文件、命名配置文件、多区域/多Provider、默认标签、IAM角色假设（Assume Role） |
| AWS特定数据源 | 31-35, 132-133, 136 | `aws_ami`（获取最新镜像）、`aws_caller_identity`、`aws_subnet`、`aws_iam_policy_document` |
| AWS核心资源 | 134-141 | IAM用户/策略/角色、启动模板、自动伸缩组、S3桶及策略、VPC/子网、安全组、EC2实例 |
| 高级后端与状态 | 74-79 | S3远程后端、S3+DynamoDB状态锁定、远程状态数据源 |
| 模块高级用法 | 100-105 | 多Provider模块、模块重构（基于AWS资源）、拆分根配置为子模块 |
| 所有实战挑战 | 150-171 | 挑战1-8均包含AWS资源部署（S3、EC2、VPC、安全组等）、状态管理、模块重构 |

## 三、纯理论无需环境
这部分占课程内容的约5%，主要是考试相关和云平台理论介绍，不需要任何实操环境。

| 课程主题 | 对应视频编号（参考） |
|----------|----------------------|
| 考试介绍与规则 | 143-149 |
| HCP Terraform理论 | 117-131 |
| 考试技巧与重点 | 147-149 |

## 补充说明
1. **部分主题的灵活处理**：
   - 资源导入（`terraform import`）：基础概念可通过导入本地`local_file`资源练习，但课程中的AWS资源导入实操需要AWS
   - 模块重构：可自己编写基于`local`/`random`资源的模块练习重构技巧，但跟随课程的AWS示例需要AWS
   - 数据来源：基础概念可通过`local_file`练习，但课程中的AWS AMI、子网等数据源需要AWS

2. **Docker本地环境推荐配置**：

直接使用 HashiCorp 官方 `hashicorp/terraform` 镜像（仅 ~45MB），无需自定义 Dockerfile：

```powershell
# 拉取镜像（仅需一次）
docker pull hashicorp/terraform:1.11

# 启动交互式练习容器（项目目录映射到 /workspace）
docker run -it --rm --name tf-practice `
  -v "D:\workshop\GitHub\Terraform-Authoring-and-Operations-Professional-Track:/workspace" `
  -w /workspace `
  --entrypoint sh `
  hashicorp/terraform:1.11
```

> 在 VS Code 中编写 `.tf` 文件，容器内运行 `terraform init/plan/apply`，双向实时同步。详细练习步骤见 `practice/GUIDE.md`。

3. **AWS权限建议**：
   实操时建议创建一个仅包含必要权限的IAM用户，避免使用根账号，权限范围覆盖EC2、S3、IAM、VPC、DynamoDB即可。

需要我帮你整理一份**Docker本地环境一键启动脚本**和**AWS最小权限策略JSON**吗？