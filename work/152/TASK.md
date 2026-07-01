# 第 152 节任务：获取挑战仓库与启动练习

## 背景

本题来自第 152 节课程内容，属于综合挑战的理论/准备阶段。目标不是创建 AWS 资源，而是明确后续挑战的解题方法、题型范围和练习节奏。

## 要求

- 理解挑战仓库的获取方式。
- 知道如何进入指定 challenge 目录开始练习。
- 建立本项目 work 目录与上机目录的对应关系。

## 验收

完成后执行：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\bootstrap.ps1
powershell -ExecutionPolicy Bypass -File scripts\verify.ps1
powershell -ExecutionPolicy Bypass -File scripts\clean.ps1
```

## 限制

- 不要启动真实 AWS 资源。
- 不要把真实 access key 写入文件。
- 不要修改 `practice/labs/152/`。
