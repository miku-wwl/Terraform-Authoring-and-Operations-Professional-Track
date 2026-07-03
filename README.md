# Terraform Authoring and Operations — Professional Track

> My goal is not merely to pass the Terraform exam. The real goal is to build the engineering discipline required to become an excellent engineer: writing reliable infrastructure code, validating changes with tests, understanding operational trade-offs, and turning Terraform knowledge into repeatable engineering practice.

A structured, hands-on learning repository for the **Terraform Authoring and Operations Professional** track. It turns course materials, study notes, lab designs, Docker-based local environments, and verifiable hands-on exercises into a practical Terraform engineering training system.

This repository is designed for active learning: read the concept, implement the lab, run the checks, fix the issues, and build the habit of treating infrastructure code like production software.

## Project Goals

This repository is not intended to be a passive note collection. It is designed to build a repeatable Terraform practice system:

- Convert abstract Terraform concepts into runnable labs.
- Turn course materials into structured study notes and practical exercises.
- Train Terraform CLI workflows, provider installation, modules, testing, backends, policy, security, and operational practices.
- Use Docker-based local environments to reduce machine-specific setup issues.
- Build engineering habits through `terraform fmt`, `terraform validate`, `terraform test`, static analysis, and repeatable lab verification.

## Who This Is For

This repository is for learners who want to move beyond simply “knowing Terraform syntax” and develop stronger Terraform engineering capability.

It is especially useful for:

- Learners preparing for Terraform Authoring and Operations Professional-level skills.
- Engineers who want hands-on Terraform practice instead of only reading documentation.
- Cloud, DevOps, SRE, and platform engineering learners who want to strengthen infrastructure-as-code fundamentals.
- Chinese-speaking learners who prefer Chinese study notes while keeping the public repository README and structure accessible in English.

## Language Note

Most study notes, lab explanations, and hands-on instructions in this repository are written in **Chinese (中文)** to accelerate learning and review.

The README is written in English so the repository remains easier to understand for a wider technical audience. If needed, AI coding assistants such as GitHub Copilot, ChatGPT, Cursor, or similar tools can translate the structured Markdown files in real time.

## Prerequisites

Recommended tools and background:

- Docker
- Git
- Basic command-line experience
- Basic Terraform CLI knowledge
- Optional: VS Code, Cursor, GitHub Copilot, or ChatGPT for assisted reading and translation

## Project Structure

| Directory | Purpose |
|---|---|
| `doc/` | Source study materials, course transcripts, and raw notes. If this repository is made public, review this directory carefully for copyright-sensitive content before publishing. |
| `practice/` | Curated tutorials and **lab design specifications**. Each lab usually includes a short summary, such as `14.md`, and a deeper explained guide, such as `14.checkov-container-explained.md`. |
| `practice/labs/` | Reference implementations used to validate lab designs and expected behavior. |
| `work/` | **Hands-on workspace.** Each `work/N` folder is a starter template for one lab. Complete the TODOs and run validation commands to verify your solution. |
| `book/` | Supplementary reading, reference material, and longer-form notes. |
| `tmp/` | Scratch area for draft documents, temporary outputs, and work-in-progress explained guides. |

## How Labs Work

Each lab under `work/` follows a consistent workflow:

1. **Read** the corresponding practice guide under `practice/`.
2. **Implement** the lab by editing the starter files in `work/N/`.
3. **Look for TODOs** such as `# TODO N:` and follow the hints.
4. **Run validation commands** inside the Docker-based Terraform environment.
5. **Fix and repeat** until the lab passes formatting, validation, and tests.

Most labs are self-contained and can be validated locally without cloud credentials unless explicitly marked otherwise.

## Running a Lab

### Option A: Run from the repository root

```sh
docker run -it --rm --name tf-work-N \
  -v "${PWD}/work/N:/workspace" \
  -w /workspace \
  --entrypoint sh \
  hashicorp/terraform:1.11
```

Inside the container:

```sh
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
```

### Option B: Run from inside a specific lab directory

```sh
cd work/14

docker run -it --rm --name tf-work-14 \
  -v "${PWD}:/workspace" \
  -w /workspace \
  --entrypoint sh \
  hashicorp/terraform:1.11
```

Inside the container:

```sh
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
```

## Topics Covered

### Terraform CLI and Automation

- `-input=false`
- `-no-color`
- `TF_IN_AUTOMATION`
- Saved plan workflow with `-out=tfplan`
- `terraform show`
- Non-interactive execution patterns

### Provider Installation and Offline Workflows

- Provider plugin cache
- Filesystem mirror
- Explicit `provider_installation`
- Air-gapped and online provider strategies

### Security, Scanning, and Policy

- Checkov code scanning
- Checkov plan scanning
- Sensitive variables and outputs
- HashiCorp Vault basics
- Vault provider basics
- HCP Terraform
- Sentinel policy concepts

### Terraform Language and Data Modeling

- Quoted strings and escape sequences
- Heredoc syntax: `<<EOT`, `<<-EOT`
- `jsonencode` and `jsondecode`
- CSV-driven resource creation
- Data types: `list`, `map`, `object`, `set`, and nested types
- `for` expressions
- Conditional expressions
- `flatten` and `distinct`
- `templatefile`
- Map iteration

### Validation, Conditions, and Testing

- Variable validation
- `contains`, `length`, `regex`
- Preconditions
- Postconditions
- `check` blocks
- Terraform test framework
- `terraform fmt`
- `terraform validate`
- `terraform test`

### State, Lifecycle, and Refactoring

- Terraform import
- `-generate-config-out`
- Resource targeting with `-target`
- Dependency direction
- `random_integer` and unique naming
- `moved` blocks
- Lifecycle meta-arguments:
  - `create_before_destroy`
  - `prevent_destroy`
  - `ignore_changes`

### Backend and Module Authoring

- S3 backend concepts
- Module authoring fundamentals
- Reusable Terraform structure
- Local validation of module behavior

## Example Lab Workflow

```sh
# Choose a lab
cd work/14

# Start the Terraform Docker environment
docker run -it --rm --name tf-work-14 \
  -v "${PWD}:/workspace" \
  -w /workspace \
  --entrypoint sh \
  hashicorp/terraform:1.11

# Inside the container
terraform init -input=false
terraform fmt -check
terraform validate
terraform test
```

## Repository Philosophy

Terraform is not just a certification topic. It is an engineering tool used to manage real infrastructure change.

This repository emphasizes:

- Clear lab structure
- Repeatable local execution
- Testable infrastructure code
- Operational thinking
- Failure-aware design
- Secure and maintainable workflows
- Practical engineering evidence over passive reading

The purpose is to build durable Terraform capability that can support real cloud, SRE, DevOps, and platform engineering work.

## License

MIT
