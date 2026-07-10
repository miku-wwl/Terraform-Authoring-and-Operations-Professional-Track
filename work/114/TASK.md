# Terraform 实操训练 114：Dependency Lock File

## 本节主旨

你要通过真实操作理解下面这句话：

```text
required_providers.version = 允许 Terraform 选择什么版本
.terraform.lock.hcl       = Terraform 上一次实际选择了什么版本
```

第一次 `terraform init` 会选择 provider，并把实际版本和 checksum 写入 `.terraform.lock.hcl`。以后普通 `terraform init` 会优先复用锁文件中的选择；`terraform init -upgrade` 才会重新选择满足当前约束的版本。

本节只使用体积较小的 `hashicorp/local` provider，不访问 AWS，也不创建任何资源。

## 阶段 1：观察已经锁定的版本

当前 `main.tf` 要求：

```hcl
version = "= 2.5.2"
```

当前目录也提供了一份锁定到 `2.5.2` 的 `.terraform.lock.hcl`。先执行：

```powershell
terraform init -input=false
```

然后在 VS Code 中打开 `.terraform.lock.hcl`，找到下面三项：

```hcl
version     = "2.5.2"
constraints = "2.5.2"
hashes      = [ ... ]
```

观察重点：

- `version` 是实际锁定的 provider 版本。
- `constraints` 来自 `main.tf` 中的版本要求。
- `hashes` 用于校验下载到的 provider package，不需要手写。

## 阶段 2：制造配置与锁文件冲突

现在只修改 `main.tf` 中的一行：

```hcl
# 修改前
version = "= 2.5.2"

# 修改后
version = "= 2.5.3"
```

先不要使用 `-upgrade`，再次运行：

```powershell
terraform init -input=false
```

这一步预期失败，不是你做错了。请在错误信息中找出这两个事实：

1. 锁文件仍然选择了 `2.5.2`。
2. 新配置要求 `2.5.3`，与现有选择不一致。

这说明普通 `init` 不会静默替换已经锁定的 provider 版本。

## 阶段 3：主动重新选择 provider

现在运行：

```powershell
terraform init -upgrade -input=false
```

`-upgrade` 的含义不是升级 Terraform CLI，而是忽略锁文件中已有的 provider 选择，按照当前版本约束重新选择。

再次打开 `.terraform.lock.hcl`，确认：

```hcl
version     = "2.5.3"
constraints = "2.5.3"
```

同时观察 `hashes`。不同 provider 版本对应的 package 不同，因此 checksum 也会随之更新。

## 阶段 4：验收

完成前三个阶段后运行：

```powershell
terraform fmt
terraform validate
terraform test
```

预期结果：

```text
Success! 1 passed, 0 failed.
```

测试会直接读取真实的 `.terraform.lock.hcl`，检查：

- 存在 `hashicorp/local` provider 条目；
- 最终锁定版本是 `2.5.3`；
- 约束记录是 `2.5.3`；
- 锁文件包含 checksum。

如果测试仍然看到 `2.5.2`，请确认你已经修改 `main.tf`，并运行了：

```powershell
terraform init -upgrade -input=false
```

## 你现在应该能回答

1. `required_providers` 中的版本约束和锁文件中的实际版本有什么区别？
2. 为什么修改版本要求后，普通 `terraform init` 会失败？
3. `terraform init -upgrade` 改变的是 Terraform CLI 版本，还是 provider 选择？
4. `.terraform/` 和 `.terraform.lock.hcl` 中，哪个通常应该提交到真实项目的 Git？
5. 锁文件是否会记住 remote module 的版本选择？

第 5 题答案：目前锁文件只跟踪 provider dependency，不记录 remote module 的版本选择。
