




- Exemplo obtido no "main.tf" do module eks:
/home/fernando/cursos/terraform/eks-via-terraform-github-actions/03-eks-via-blueprint-argocd/.terraform/modules/eks/main.tf

~~~~h
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_session_context" "current" {
  # This data source provides information on the IAM source role of an STS assumed role
  # For non-role ARNs, this data source simply passes the ARN through issuer ARN
  # Ref https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2327#issuecomment-1355581682
  # Ref https://github.com/hashicorp/terraform-provider-aws/issues/28381
  arn = data.aws_caller_identity.current.arn
}
~~~~



- Exemplo de Output:

~~~~h
output "current_arn_teste" {
  description = "Current ARN - TESTE."
  value       = data.aws_caller_identity.current.arn
}
~~~~

