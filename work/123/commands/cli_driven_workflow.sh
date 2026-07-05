#!/usr/bin/env sh
# Commands for an HCP Terraform CLI-driven workflow.
# The local CLI starts the run, while the linked HCP Terraform workspace executes it remotely.

# TODO 5: Initialize the local working directory so it is linked to the HCP Terraform workspace.
terraform init -input=false

# TODO 6: Start a remote plan from the local terminal.
terraform TODO

# TODO 7: Start a remote apply from the local terminal.
terraform TODO

# TODO 8: Start a remote destroy from the local terminal.
terraform TODO
