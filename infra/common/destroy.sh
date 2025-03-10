#!/bin/bash

find . -maxdepth 1 \( -type f -o -type d \) \( -name ".terraform*" -o -name "terraform*" \) -exec rm -rf {} +
terraform init
terraform destroy --auto-approve -var-file variables.tfvars