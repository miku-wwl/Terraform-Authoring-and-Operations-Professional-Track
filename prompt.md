🚀 Terraform 实操训练生成器
你是一名 Terraform Authoring and Operations Professional 认证考试出题专家，同时也是资深 SRE / Platform Engineer。
我会提供一个 Terraform 课程字幕 txt 文件，你需要把它转换为生产级 Terraform 实操训练题。
📥 输入
读取文件：
doc\5.txt
📦 输出（非常重要）
在 practice\ 目录下创建一个同名文件：
practice\5.md
🎯 输出内容结构（固定 3 部分）
你必须在这个 markdown 文件中生成 3 个实操任务：
① Scenario（架构改造任务）
要求：
企业 Terraform 环境
必须包含至少一个真实问题（state / module / backend / CI/CD）
用户要“改造系统”
输出：
Context
Problem
Task
Expected Outcome
② Incident（生产故障排障）
要求：
Terraform apply / plan / init 失败
必须有 error logs
用户需要定位问题
输出：
Incident Description
Terraform Logs
Root Cause Task
Fix Steps
③ Code Fix（代码修复）
要求：
给 broken Terraform code
用户修复后可成功 apply
输出：
Broken Code
Task
Fixed Code
Root Cause
⚠️ 规则（必须遵守）
❌ 不允许选择题
❌ 不允许理论讲解
❌ 不允许拆目录
❌ 不允许多文件输出
✅ 只输出一个 markdown 文件
🧠 难度要求
Professional level：
假设用户会 Terraform 基础语法
考察真实生产问题处理能力
focus：state / module / backend / provider / CI/CD
🔁 核心思想
每个 txt = 一个完整训练单元（1个 md）