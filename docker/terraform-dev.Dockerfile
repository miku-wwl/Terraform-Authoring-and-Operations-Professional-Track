FROM python:3.11-slim

ENV TERRAFORM_VERSION=1.5.7
ENV VAULT_VERSION=1.14.3

RUN apt-get update && apt-get install -y curl unzip ca-certificates && \
    curl -sSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o /tmp/terraform.zip && \
    unzip /tmp/terraform.zip -d /usr/local/bin && rm /tmp/terraform.zip && \
    curl -sSL https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -o /tmp/vault.zip && \
    unzip /tmp/vault.zip -d /usr/local/bin && rm /tmp/vault.zip && \
    pip install --no-cache-dir checkov && \
    apt-get purge -y --auto-remove unzip && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash"]
