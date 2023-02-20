
git status
git add .
git commit -m "Projeto - eks-via-terraform-github-actions"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status




- Plan do projeto



Plan: 37 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + azs                                = [
      + "us-east-1a",
      + "us-east-1b",
      + "us-east-1c",
      + "us-east-1d",
      + "us-east-1e",
      + "us-east-1f",
    ]
  + cluster_arn                        = (known after apply)
  + cluster_certificate_authority_data = (known after apply)
  + cluster_endpoint                   = (known after apply)
  + cluster_iam_role_arn               = (known after apply)
  + cluster_iam_role_name              = "hr-stag-eks-master-role"
  + cluster_id                         = (known after apply)
  + cluster_oidc_issuer_url            = (known after apply)
  + cluster_primary_security_group_id  = (known after apply)
  + cluster_version                    = "1.22"
  + ec2_bastion_public_instance_ids    = (known after apply)
  + ec2_bastion_public_ip              = (known after apply)
  + nat_public_ips                     = [
      + (known after apply),
    ]
  + node_group_public_arn              = (known after apply)
  + node_group_public_id               = (known after apply)
  + node_group_public_status           = (known after apply)
  + node_group_public_version          = (known after apply)
  + private_subnets                    = [
      + (known after apply),
      + (known after apply),
    ]
  + public_subnets                     = [
      + (known after apply),
      + (known after apply),
    ]
  + vpc_cidr_block                     = "10.0.0.0/16"
  + vpc_id                             = (known after apply)







git filter-branch -f --index-filter 'git rm --cached --ignore-unmatch 08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests/.terraform/providers/registry.terraform.io/hashicorp/aws/3.76.1/linux_amd64/terraform-provider-aws_v3.76.1_x5'










# Dia 20/02/2023




- Aplicando o cluster
17:15h



- Status atual
17:20h
aws_eks_cluster.eks_cluster: Still creating... [8m30s elapsed]
aws_eks_cluster.eks_cluster: Still creating... [8m40s elapsed]
aws_eks_cluster.eks_cluster: Still creating... [8m50s elapsed]





- Acusou erro:

~~~~bash
aws_eks_cluster.eks_cluster: Still creating... [10m10s elapsed]
aws_eks_cluster.eks_cluster: Creation complete after 10m10s [id=hr-stag-eksdemo1]
aws_eks_node_group.eks_ng_public: Creating...
╷
│ Error: error creating EKS Node Group (hr-stag-eksdemo1:hr-stag-eks-ng-public): InvalidParameterException: KeyPair eks-terraform-key not found
│ {
│   RespMetadata: {
│     StatusCode: 400,
│     RequestID: "d46d4609-9f90-4c6c-88aa-a8f6e7575a0d"
│   },
│   ClusterName: "hr-stag-eksdemo1",
│   Message_: "KeyPair eks-terraform-key not found",
│   NodegroupName: "hr-stag-eks-ng-public"
│ }
│
│   with aws_eks_node_group.eks_ng_public,
│   on c5-07-eks-node-group-public.tf line 2, in resource "aws_eks_node_group" "eks_ng_public":
│    2: resource "aws_eks_node_group" "eks_ng_public" {
│
╵
╷
│ Error: Error launching source instance: InvalidKeyPair.NotFound: The key pair 'eks-terraform-key' does not exist
│       status code: 400, request id: cc799d70-2b2d-46ea-8626-20b580c1f3a0
│
│   with module.ec2_public.aws_instance.this[0],
│   on .terraform/modules/ec2_public/main.tf line 5, in resource "aws_instance" "this":
│    5: resource "aws_instance" "this" {
│
╵
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$
~~~~







- Criada Key na AWS

fernando-devops-20-02-2023








- Novo erro:

~~~~bash
null_resource.copy_ec2_keys: Still creating... [1m41s elapsed]
null_resource.copy_ec2_keys: Still creating... [1m51s elapsed]
null_resource.copy_ec2_keys: Still creating... [2m1s elapsed]
null_resource.copy_ec2_keys: Still creating... [2m11s elapsed]
null_resource.copy_ec2_keys: Still creating... [2m21s elapsed]
null_resource.copy_ec2_keys: Still creating... [2m31s elapsed]
null_resource.copy_ec2_keys: Still creating... [2m41s elapsed]
null_resource.copy_ec2_keys: Still creating... [2m51s elapsed]
null_resource.copy_ec2_keys: Still creating... [3m1s elapsed]
null_resource.copy_ec2_keys: Still creating... [3m11s elapsed]
null_resource.copy_ec2_keys: Still creating... [3m21s elapsed]
null_resource.copy_ec2_keys: Still creating... [3m31s elapsed]
null_resource.copy_ec2_keys: Still creating... [3m41s elapsed]
null_resource.copy_ec2_keys: Still creating... [3m51s elapsed]
null_resource.copy_ec2_keys: Still creating... [4m1s elapsed]
null_resource.copy_ec2_keys: Still creating... [4m11s elapsed]
null_resource.copy_ec2_keys: Still creating... [4m21s elapsed]
null_resource.copy_ec2_keys: Still creating... [4m31s elapsed]
null_resource.copy_ec2_keys: Still creating... [4m41s elapsed]
null_resource.copy_ec2_keys: Still creating... [4m51s elapsed]
╷
│ Error: file provisioner error
│
│   with null_resource.copy_ec2_keys,
│   on c4-07-ec2bastion-provisioners.tf line 14, in resource "null_resource" "copy_ec2_keys":
│   14:   provisioner "file" {
│
│ timeout - last error: SSH authentication failed (ec2-user@100.24.217.93:22): ssh: handshake failed: ssh: unable to authenticate, attempted methods [none publickey], no supported
│ methods remain
╵
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$

~~~~