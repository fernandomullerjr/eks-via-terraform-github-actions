

# 07-eks-lab

- Projeto usando eks-blueprint
https://catalog.workshops.aws/eks-blueprints-terraform/en-US/030-provision-eks-cluster/1-create-a-terraform-project




Next, run the following terraform CLI commands to provision the AWS resources.

1
2
# initialize terraform so that we get all the required modules and providers
terraform init

View Terraform Output

1
2
# Always a good practice to use a dry-run command
terraform plan

If no errors you can proceed with deployment

1
2
# The auto approve flag avoids you having to confirm you want to provision resources.
terraform apply -auto-approve








- Erro


fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab$ terraform init
There are some problems with the configuration, described below.

The Terraform configuration must be valid before initialization so that
Terraform can determine which modules and providers need to be installed.
╷
│ Error: Invalid escape sequence
│
│ On main.tf line 20: The symbol "$" is not a valid escape sequence selector.
╵

╷
│ Error: Invalid escape sequence
│
│ On main.tf line 22: The symbol "$" is not a valid escape sequence selector.
╵

╷
│ Error: Invalid escape sequence
│
│ On main.tf line 24: The symbol "$" is not a valid escape sequence selector.
╵

╷
│ Error: Invalid escape sequence
│
│ On main.tf line 27: The symbol "$" is not a valid escape sequence selector.
╵

╷
│ Error: Invalid escape sequence
│
│ On main.tf line 32: The symbol "$" is not a valid escape sequence selector.
╵

fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab$
