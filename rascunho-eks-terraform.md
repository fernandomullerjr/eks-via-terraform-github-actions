

----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

# Git - Efetuando Push
git status
git add -u
git reset -- 01-eks-cluster-terraform-simples/.terraform
git reset -- 01-eks-cluster-terraform-simples/.terraform/*
git reset -- 02-eks-via-blueprint/.terraform
git reset -- 02-eks-via-blueprint/.terraform*
git reset -- 03-eks-via-blueprint-argocd/.terraform
git reset -- 03-eks-via-blueprint-argocd/.terraform*
git commit -m "Projeto - eks-via-terraform-github-actions"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status

- Git - add sem colocar .terraform:
git add -u
git reset -- 01-eks-cluster-terraform-simples/.terraform
git reset -- 01-eks-cluster-terraform-simples/.terraform/*


- Erro - arquivo pesado:
git filter-branch -f --index-filter 'git rm --cached --ignore-unmatch 08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests/.terraform/providers/registry.terraform.io/hashicorp/aws/3.76.1/linux_amd64/terraform-provider-aws_v3.76.1_x5'





----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

# Comandos e detalhes úteis
- Para subir o projeto é necessário alterar o nome da AWS Key nas variáveis. Criar uma Key na mesma região que o projeto vai ser deployado.
- Necessário ajustar o valor da chave no arquivo "eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests/private-key/eks-terraform-key.pem"
- Projeto usa uma EC2 Amazon Linux 2, cuidar para utilizar o usuário ec2-user nas conexões via SSH.





----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

# Rascunho

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








git filter-branch -f --index-filter 'git rm --cached --ignore-unmatch 08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests/.terraform/providers/registry.terraform.io/hashicorp/aws/3.76.1/linux_amd64/terraform-provider-aws_v3.76.1_x5'








- Ajustada a chave SSH
eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests/private-key/eks-terraform-key.pem
colocado o valor da chave criada na AWS

- Fazendo novo apply:
terraform apply -auto-approve


~~~~bash

fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ terraform apply -auto-approve
╷
│ Error: Required plugins are not installed
│
│ The installed provider plugins are not consistent with the packages selected in the dependency lock file:
│   - registry.terraform.io/hashicorp/aws: there is no package for registry.terraform.io/hashicorp/aws 3.76.1 cached in .terraform/providers
│
│ Terraform uses external plugins to integrate with a variety of different infrastructure services. To download the plugins required for this configuration, run:
│   terraform init
╵
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ terraform init
Initializing modules...

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Reusing previous version of hashicorp/null from the dependency lock file
- Installing hashicorp/aws v3.76.1...
- Installed hashicorp/aws v3.76.1 (signed by HashiCorp)
- Using previously-installed hashicorp/null v3.2.1

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ terraform apply -auto-approve
aws_iam_role.eks_nodegroup_role: Refreshing state... [id=hr-stag-eks-nodegroup-role]
aws_iam_role.eks_master_role: Refreshing state... [id=hr-stag-eks-master-role]
module.vpc.aws_vpc.this[0]: Refreshing state... [id=vpc-0e7f8e1665fd0e30f]
module.vpc.aws_eip.nat[0]: Refreshing state... [id=eipalloc-0c704ba176abd808a]
aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController: Refreshing state... [id=hr-stag-eks-master-role-20230220200558157800000003]
aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy: Refreshing state... [id=hr-stag-eks-master-role-20230220200558148500000001]
aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy: Refreshing state... [id=hr-stag-eks-nodegroup-role-20230220200558158100000004]
aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy: Refreshing state... [id=hr-stag-eks-nodegroup-role-20230220200558157200000002]
aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly: Refreshing state... [id=hr-stag-eks-nodegroup-role-20230220200558190100000005]
module.vpc.aws_subnet.public[0]: Refreshing state... [id=subnet-088048b340bbff294]
module.vpc.aws_subnet.public[1]: Refreshing state... [id=subnet-043a48c6c3bd84ebd]
module.vpc.aws_route_table.private[0]: Refreshing state... [id=rtb-0f70319bd3fff9961]
module.vpc.aws_internet_gateway.this[0]: Refreshing state... [id=igw-02924911fd6181e23]
module.vpc.aws_subnet.private[0]: Refreshing state... [id=subnet-03af236bb194d6102]
module.vpc.aws_route_table.public[0]: Refreshing state... [id=rtb-0c8d6ef57d4577f94]
module.vpc.aws_subnet.private[1]: Refreshing state... [id=subnet-0ce5c453fa9061cfc]
module.public_bastion_sg.aws_security_group.this_name_prefix[0]: Refreshing state... [id=sg-08479234f7551bb43]
module.vpc.aws_subnet.database[0]: Refreshing state... [id=subnet-0587fb34516e6188d]
module.vpc.aws_route_table.database[0]: Refreshing state... [id=rtb-084d045a8f601a5a6]
module.vpc.aws_subnet.database[1]: Refreshing state... [id=subnet-084b02e51edb629a3]
module.vpc.aws_route_table_association.private[1]: Refreshing state... [id=rtbassoc-018dd3945b42c1faf]
module.vpc.aws_route_table_association.private[0]: Refreshing state... [id=rtbassoc-04e417df88733f07d]
module.public_bastion_sg.aws_security_group_rule.egress_rules[0]: Refreshing state... [id=sgrule-3621997232]
module.public_bastion_sg.aws_security_group_rule.ingress_rules[0]: Refreshing state... [id=sgrule-1014773840]
module.vpc.aws_route.public_internet_gateway[0]: Refreshing state... [id=r-rtb-0c8d6ef57d4577f941080289494]
module.vpc.aws_route_table_association.public[0]: Refreshing state... [id=rtbassoc-0737af1cc06071ead]
module.vpc.aws_route_table_association.public[1]: Refreshing state... [id=rtbassoc-04a702e28e2e1f325]
module.vpc.aws_nat_gateway.this[0]: Refreshing state... [id=nat-0fc13cc65deb48be7]
aws_eks_cluster.eks_cluster: Refreshing state... [id=hr-stag-eksdemo1]
module.ec2_public.aws_instance.this[0]: Refreshing state... [id=i-0d3e6a230d9849a49]
module.vpc.aws_route_table_association.database[0]: Refreshing state... [id=rtbassoc-0116ad1faca650c10]
module.vpc.aws_db_subnet_group.database[0]: Refreshing state... [id=hr-stag-eksdemo1]
module.vpc.aws_route_table_association.database[1]: Refreshing state... [id=rtbassoc-041d8f5edf8773ead]
module.vpc.aws_route.private_nat_gateway[0]: Refreshing state... [id=r-rtb-0f70319bd3fff99611080289494]
aws_eks_node_group.eks_ng_public: Refreshing state... [id=hr-stag-eksdemo1:hr-stag-eks-ng-public]
aws_eip.bastion_eip: Refreshing state... [id=eipalloc-0529f39962271c5b6]
null_resource.copy_ec2_keys: Refreshing state... [id=2035717291313318247]

Note: Objects have changed outside of Terraform

Terraform detected the following changes made outside of Terraform since the last "terraform apply":

  # aws_eks_node_group.eks_ng_public has changed
  ~ resource "aws_eks_node_group" "eks_ng_public" {
        id              = "hr-stag-eksdemo1:hr-stag-eks-ng-public"
      + labels          = {}
        tags            = {
            "Name" = "Public-Node-Group"
        }
        # (14 unchanged attributes hidden)

      ~ remote_access {
          + source_security_group_ids = []
            # (1 unchanged attribute hidden)
        }


        # (2 unchanged blocks hidden)
    }

  # module.ec2_public.aws_instance.this[0] has changed
  ~ resource "aws_instance" "this" {
        id                                   = "i-0d3e6a230d9849a49"
      ~ public_dns                           = "ec2-75-101-236-217.compute-1.amazonaws.com" -> "ec2-100-24-217-93.compute-1.amazonaws.com"
      ~ public_ip                            = "75.101.236.217" -> "100.24.217.93"
        tags                                 = {
            "Name"        = "hr-stag-BastionHost"
            "environment" = "stag"
            "owners"      = "hr"
        }
        # (28 unchanged attributes hidden)






        # (6 unchanged blocks hidden)
    }


Unless you have made equivalent changes to your configuration, or ignored the relevant attributes using ignore_changes, the following plan may include actions to undo or respond to
these changes.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # null_resource.copy_ec2_keys is tainted, so must be replaced
-/+ resource "null_resource" "copy_ec2_keys" {
      ~ id = "2035717291313318247" -> (known after apply)
    }

Plan: 1 to add, 0 to change, 1 to destroy.
null_resource.copy_ec2_keys: Destroying... [id=2035717291313318247]
null_resource.copy_ec2_keys: Destruction complete after 0s
null_resource.copy_ec2_keys: Creating...
null_resource.copy_ec2_keys: Provisioning with 'file'...
null_resource.copy_ec2_keys: Provisioning with 'remote-exec'...
null_resource.copy_ec2_keys (remote-exec): Connecting to remote host via SSH...
null_resource.copy_ec2_keys (remote-exec):   Host: 100.24.217.93
null_resource.copy_ec2_keys (remote-exec):   User: ec2-user
null_resource.copy_ec2_keys (remote-exec):   Password: false
null_resource.copy_ec2_keys (remote-exec):   Private key: true
null_resource.copy_ec2_keys (remote-exec):   Certificate: false
null_resource.copy_ec2_keys (remote-exec):   SSH Agent: false
null_resource.copy_ec2_keys (remote-exec):   Checking Host Key: false
null_resource.copy_ec2_keys (remote-exec):   Target Platform: unix
null_resource.copy_ec2_keys (remote-exec): Connected!
null_resource.copy_ec2_keys: Provisioning with 'local-exec'...
null_resource.copy_ec2_keys (local-exec): Executing: ["/bin/sh" "-c" "echo VPC created on `date` and VPC ID: vpc-0e7f8e1665fd0e30f >> creation-time-vpc-id.txt"]
null_resource.copy_ec2_keys: Creation complete after 7s [id=2028636124722750820]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.

Outputs:

azs = tolist([
  "us-east-1a",
  "us-east-1b",
  "us-east-1c",
  "us-east-1d",
  "us-east-1e",
  "us-east-1f",
])
cluster_arn = "arn:aws:eks:us-east-1:261106957109:cluster/hr-stag-eksdemo1"
cluster_certificate_authority_data = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1ESXlNREl3TVRJeE9Gb1hEVE16TURJeE56SXdNVEl4T0Zvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTlBjCm5VR2RqeUVKaXBHbnFNbG1oWkJXMHptdFpBRzBnd1ZIZWJYdHBvVmIvSzQ5ZXFzclhyN0VnMVk5cVZ1SVo3clIKZGhad01mekxqbkRjYmtSTldFZ2hucnRNU0d1OXYxZXlMTkloclMvdkkvM2loeGRDUm93dTQ0WS92aVZpeU9CaQppZTBWYTdrUGxiN1NYeDlCZVNxeGhIcFBsbE96NURPY1BsbnMrNnMxb1JGYlRjbXhQamFkR1dKemRCaWlWSzdCCjl1eFMrMkVOZVBFcG9IMXAvYVM2NHI1YzZaekRmT0RvNFZIZkpzaHJPcVU0bDlZYVA1RHhhY0F0czkyQUwxdi8KbUVOazdwU1dzZlprTkNKWVZMQTBXQ3RkcndxamhaRTg3dzBvYit3TnU3VWlzT1BCeWlBU0pOQnZBd3RJMkw1SwpzTFNhU2V6S1NmUWVQbGs5VXpFQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZJM2NKMm1WSC8vM05IOCtNU0ZUc2wyLyszd3dNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBR1BaT3VDWHJmY1oxK3RVNnhBRQoxelY4QllWTzRsUkNoSGFMNFp1WGtNSUt0VUk1UEpIazdJcGpvMjNTdldUNWhsa0tkS2lEbEptdmtiZVZrdm5vCmRPNWgyNWkwbVY0R1ZVUStpMjZVQTkzbTNBSmhxRkx0Ylpxc0YyR2hUM2t3UnZQT1hyRWFFdk03RjNlYlQ3VEcKWGpRWjhBY0Z0cDBnYlo3dytEU01tbS9LUG9xSW5kRWNGdFZWNlBTWVEvdnVkYlI4NDlNRllPQndTQkVidHp6bQp5YW1RMWF3QkRYbHJLUGRpS2djM0hsbUFSVjRzVi9XOHdBZ1VLWUJTQnRybUN1a05lZDhzbC9oWmdhODVyMVZPCkxZT1JVaXZ6UmU1RlJkUTBDV3kvdWJ6SW81TWlrRVlIZ3cvLzJrenpwalVFZnNCd0RYc2VZN2dFaXQ2NG5hcHUKeGxvPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="
cluster_endpoint = "https://0D61E19D1E30742164D16190D2820BC1.gr7.us-east-1.eks.amazonaws.com"
cluster_iam_role_arn = "arn:aws:iam::261106957109:role/hr-stag-eks-master-role"
cluster_iam_role_name = "hr-stag-eks-master-role"
cluster_id = "hr-stag-eksdemo1"
cluster_oidc_issuer_url = "https://oidc.eks.us-east-1.amazonaws.com/id/0D61E19D1E30742164D16190D2820BC1"
cluster_primary_security_group_id = "sg-0ef02cc25c41c5734"
cluster_version = "1.22"
ec2_bastion_public_instance_ids = "i-0d3e6a230d9849a49"
ec2_bastion_public_ip = "100.24.217.93"
nat_public_ips = tolist([
  "34.224.208.50",
])
node_group_public_arn = "arn:aws:eks:us-east-1:261106957109:nodegroup/hr-stag-eksdemo1/hr-stag-eks-ng-public/f4c3383f-1954-3f7a-33bb-5ba572ae9c32"
node_group_public_id = "hr-stag-eksdemo1:hr-stag-eks-ng-public"
node_group_public_status = "ACTIVE"
node_group_public_version = "1.22"
private_subnets = [
  "subnet-03af236bb194d6102",
  "subnet-0ce5c453fa9061cfc",
]
public_subnets = [
  "subnet-088048b340bbff294",
  "subnet-043a48c6c3bd84ebd",
]
vpc_cidr_block = "10.0.0.0/16"
vpc_id = "vpc-0e7f8e1665fd0e30f"
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$

~~~~





ec2_bastion_public_instance_ids = "i-0d3e6a230d9849a49"
ec2_bastion_public_ip = "100.24.217.93"


- Logando na EC2 - Bastion:
100.24.217.93


~~~~bash

Last login: Mon Feb 20 20:46:29 2023 from 45.177.153.235

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
[ec2-user@ip-10-0-101-148 ~]$ ls
[ec2-user@ip-10-0-101-148 ~]$ ls /
bin  boot  dev  etc  home  lib  lib64  local  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
[ec2-user@ip-10-0-101-148 ~]$
[ec2-user@ip-10-0-101-148 ~]$
[ec2-user@ip-10-0-101-148 ~]$ pwd
/home/ec2-user
[ec2-user@ip-10-0-101-148 ~]$ hostname
ip-10-0-101-148.ec2.internal
[ec2-user@ip-10-0-101-148 ~]$

~~~~



- Conferindo o histórico de criação de VPC:

~~~~bash
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ ls local-exec-output-files/
creation-time-vpc-id.txt
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ cat local-exec-output-files/creation-time-vpc-id.txt
VPC created on Tue Nov 23 10:08:37 IST 2021 and VPC ID: vpc-03096ec894a1ae08f
VPC created on Thu Nov 25 11:11:15 IST 2021 and VPC ID: vpc-09e7161372a8333dd
VPC created on Thu Nov 25 12:07:10 IST 2021 and VPC ID: vpc-047e41ced4f4f53b6
VPC created on Thu Nov 25 15:26:32 IST 2021 and VPC ID: vpc-0268beee06316a180
VPC created on Wed Dec 22 07:17:20 IST 2021 and VPC ID: vpc-02b1e5c8c33d70911
VPC created on Wed Dec 22 13:49:57 IST 2021 and VPC ID: vpc-00a7881c4d6c4c731
VPC created on Wed Dec 22 17:30:58 IST 2021 and VPC ID: vpc-06da5393d5481d8ba
VPC created on Wed Dec 22 18:09:24 IST 2021 and VPC ID: vpc-0ce0a44123c32a304
VPC created on Wed Dec 22 18:48:15 IST 2021 and VPC ID: vpc-0475c7bd01fff3f8e
VPC created on Thu Dec 23 07:39:28 IST 2021 and VPC ID: vpc-0bfd05ddf2d2fb57f
VPC created on Thu Dec 23 10:05:07 IST 2021 and VPC ID: vpc-025c4f234974bc13c
VPC created on Thu Dec 30 13:50:17 IST 2021 and VPC ID: vpc-075bbf88311579923
VPC created on Thu Dec 30 15:48:07 IST 2021 and VPC ID: vpc-0e524e587e67e9c6f
VPC created on Fri Dec 31 08:38:31 IST 2021 and VPC ID: vpc-01da91a4c1a2507e4
VPC created on Sat Jan 1 06:02:20 IST 2022 and VPC ID: vpc-063592bf66bbe415c
VPC created on Sun Jan 2 09:02:31 IST 2022 and VPC ID: vpc-07b2456bdfba15335
VPC created on Mon Jan 3 07:19:15 IST 2022 and VPC ID: vpc-0b1ccfc81d2c1115a
VPC created on Mon 20 Feb 2023 05:46:30 PM -03 and VPC ID: vpc-0e7f8e1665fd0e30f
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$
~~~~




- Funcionou, criou tudo.



# Git - Efetuando Push
git status
git add .
git commit -m "Projeto - eks-via-terraform-github-actions"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status


- Criado arquivo gitignore
eks-via-terraform-github-actions/Terraform.gitignore



- Erro arquivo pesado:

Total 23 (delta 6), reused 0 (delta 0)
remote: Resolving deltas: 100% (6/6), completed with 5 local objects.
remote: error: Trace: 0ac4fefef809ea515b40885e3379ccce50fba3ed4bea810a45e5cc101075c472
remote: error: See http://git.io/iEPt8g for more information.
remote: error: File 08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests/.terraform/providers/registry.terraform.io/hashicorp/aws/3.76.1/linux_amd64/terraform-provider-aws_v3.76.1_x5 is 245.06 MB; this exceeds GitHub's file size limit of 100.00 MB
remote: error: GH001: Large files detected. You may want to try Git Large File Storage - https://git-lfs.github.com.
To github.com:fernandomullerjr/eks-via-terraform-github-actions.git
 ! [remote rejected] main -> main (pre-receive hook declined)
error: failed to push some refs to 'git@github.com:fernandomullerjr/eks-via-terraform-github-actions.git'
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions$




git filter-branch -f --index-filter 'git rm --cached --ignore-unmatch 08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests/.terraform/providers/registry.terraform.io/hashicorp/aws/3.76.1/linux_amd64/terraform-provider-aws_v3.76.1_x5'




- Erro na Console:
Your current user or role does not have access to Kubernetes objects on this EKS cluster





fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ aws eks --region us-east-1 update-kubeconfig --name hr-stag-eksdemo1
Added new context arn:aws:eks:us-east-1:261106957109:cluster/hr-stag-eksdemo1 to /home/fernando/.kube/config
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ kubectl get nodes
NAME                          STATUS   ROLES    AGE   VERSION
ip-10-0-102-71.ec2.internal   Ready    <none>   42m   v1.22.17-eks-49d8fe8
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$



kubectl describe -n kube-system configmap/aws-auth

kubectl edit -n kube-system configmap/aws-auth



- Criando a Role
my-console-viewer-role

- Criando policy
my-console-viewer-policy


~~~~JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:ListFargateProfiles",
                "eks:DescribeNodegroup",
                "eks:ListNodegroups",
                "eks:ListUpdates",
                "eks:AccessKubernetesApi",
                "eks:ListAddons",
                "eks:DescribeCluster",
                "eks:DescribeAddonVersions",
                "eks:ListClusters",
                "eks:ListIdentityProviderConfigs",
                "iam:ListRoles"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "ssm:GetParameter",
            "Resource": "arn:aws:ssm:*:261106957109:parameter/*"
        }
    ]
}  
~~~~





- Aplicando no Cluster a estrutura RBAC
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/docs/eks-console-full-access.yaml
kubectl apply -f eks-console-full-access.yaml

fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ kubectl apply -f eks-console-full-access.yaml
clusterrole.rbac.authorization.k8s.io/eks-console-dashboard-full-access-clusterrole created
clusterrolebinding.rbac.authorization.k8s.io/eks-console-dashboard-full-access-binding created
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$



- Editando trust policy da role:

~~~~JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::261106957109:fernando-devops"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
~~~~


- These examples assume that you attached the IAM permissions in the first step to a role named my-console-viewer-role and a user named my-user. Replace 111122223333 with your AWS account ID.

- Exemplo

~~~~YAML
apiVersion: v1
data:
mapRoles: |
  - groups:
    - eks-console-dashboard-full-access-group
    rolearn: arn:aws:iam::111122223333:role/my-console-viewer-role
    username: my-console-viewer-role        
mapUsers: |
  - groups:
    - eks-console-dashboard-restricted-access-group
    userarn: arn:aws:iam::111122223333:user/my-user
    username: my-user
~~~~




- Editado:

~~~~YAML
apiVersion: v1
data:
  mapRoles: |
    - groups:
      - eks-console-dashboard-full-access-group
      rolearn: arn:aws:iam::261106957109:role/my-console-viewer-role
      username: my-console-viewer-role        
  mapUsers: |
    - groups:
      - eks-console-dashboard-full-access-group
      userarn: arn:aws:iam::261106957109:user/fernando-devops
      username: fernando-devops
~~~~




kubectl describe -n kube-system configmap/aws-auth

kubectl edit -n kube-system configmap/aws-auth



- ANTES:

~~~~bash
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ kubectl describe -n kube-system configmap/aws-auth
Name:         aws-auth
Namespace:    kube-system
Labels:       <none>
Annotations:  <none>

Data
====
mapRoles:
----
- groups:
  - system:bootstrappers
  - system:nodes
  rolearn: arn:aws:iam::261106957109:role/hr-stag-eks-nodegroup-role
  username: system:node:{{EC2PrivateDNSName}}


BinaryData
====

Events:  <none>
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ date
Mon 20 Feb 2023 06:28:32 PM -03
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$
~~~~


- DEPOIS:

~~~~bash

fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ kubectl describe -n kube-system configmap/aws-auth
Name:         aws-auth
Namespace:    kube-system
Labels:       <none>
Annotations:  <none>

Data
====
mapRoles:
----
- groups:
  - system:bootstrappers
  - system:nodes
  rolearn: arn:aws:iam::261106957109:role/hr-stag-eks-nodegroup-role
  username: system:node:{{EC2PrivateDNSName}}
- groups:
  - eks-console-dashboard-full-access-group
  rolearn: arn:aws:iam::261106957109:role/my-console-viewer-role
  username: my-console-viewer-role

mapUsers:
----
- groups:
  - eks-console-dashboard-full-access-group
  userarn: arn:aws:iam::261106957109:user/fernando-devops
  username: fernando-devops


BinaryData
====

Events:  <none>
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ date
Mon 20 Feb 2023 06:30:20 PM -03
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$

~~~~



- Tratado o erro "Your current user or role does not have access to Kubernetes objects on this EKS cluster".
Solução completa em:
/home/fernando/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests/troubleshooting/EKS - Console - Your current user or role does not have access to Kubernetes objects on this EKS cluster.md


git filter-branch -f --index-filter 'git rm --cached --ignore-unmatch 08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests/.terraform/providers/registry.terraform.io/hashicorp/aws/3.76.1/linux_amd64/terraform-provider-aws_v3.76.1_x5'



- Cluster todo ok

~~~~bash
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ kubectl get pods -A
NAMESPACE     NAME                      READY   STATUS    RESTARTS   AGE
kube-system   aws-node-brh6x            1/1     Running   0          93m
kube-system   coredns-7f5998f4c-58xkp   1/1     Running   0          104m
kube-system   coredns-7f5998f4c-jldlb   1/1     Running   0          104m
kube-system   kube-proxy-8tg2t          1/1     Running   0          93m
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ kubectl get all -A
NAMESPACE     NAME                          READY   STATUS    RESTARTS   AGE
kube-system   pod/aws-node-brh6x            1/1     Running   0          93m
kube-system   pod/coredns-7f5998f4c-58xkp   1/1     Running   0          104m
kube-system   pod/coredns-7f5998f4c-jldlb   1/1     Running   0          104m
kube-system   pod/kube-proxy-8tg2t          1/1     Running   0          93m

NAMESPACE     NAME                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)         AGE
default       service/kubernetes   ClusterIP   172.20.0.1    <none>        443/TCP         104m
kube-system   service/kube-dns     ClusterIP   172.20.0.10   <none>        53/UDP,53/TCP   104m

NAMESPACE     NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
kube-system   daemonset.apps/aws-node     1         1         1       1            1           <none>          104m
kube-system   daemonset.apps/kube-proxy   1         1         1       1            1           <none>          104m

NAMESPACE     NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/coredns   2/2     2            2           104m

NAMESPACE     NAME                                DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/coredns-7f5998f4c   2         2         2       104m
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ ^C
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ ^C
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ ^C
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ ^C
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ ^C
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ ^C
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ ^C
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$ date
Mon 20 Feb 2023 06:59:29 PM -03
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$

~~~~








- Efetuando o destroy:

~~~~bash

aws_iam_role.eks_nodegroup_role: Destruction complete after 4s
aws_eks_cluster.eks_cluster: Still destroying... [id=hr-stag-eksdemo1, 11s elapsed]
aws_eks_cluster.eks_cluster: Still destroying... [id=hr-stag-eksdemo1, 21s elapsed]
aws_eks_cluster.eks_cluster: Still destroying... [id=hr-stag-eksdemo1, 31s elapsed]
aws_eks_cluster.eks_cluster: Still destroying... [id=hr-stag-eksdemo1, 41s elapsed]
aws_eks_cluster.eks_cluster: Still destroying... [id=hr-stag-eksdemo1, 51s elapsed]
aws_eks_cluster.eks_cluster: Still destroying... [id=hr-stag-eksdemo1, 1m1s elapsed]
aws_eks_cluster.eks_cluster: Still destroying... [id=hr-stag-eksdemo1, 1m11s elapsed]
aws_eks_cluster.eks_cluster: Still destroying... [id=hr-stag-eksdemo1, 1m21s elapsed]
aws_eks_cluster.eks_cluster: Destruction complete after 1m26s
aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy: Destroying... [id=hr-stag-eks-master-role-20230220200558148500000001]
aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController: Destroying... [id=hr-stag-eks-master-role-20230220200558157800000003]
module.vpc.aws_subnet.public[0]: Destroying... [id=subnet-088048b340bbff294]
module.vpc.aws_subnet.public[1]: Destroying... [id=subnet-043a48c6c3bd84ebd]
aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy: Destruction complete after 1s
aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController: Destruction complete after 1s
aws_iam_role.eks_master_role: Destroying... [id=hr-stag-eks-master-role]
module.vpc.aws_subnet.public[0]: Destruction complete after 2s
module.vpc.aws_subnet.public[1]: Destruction complete after 2s
module.vpc.aws_vpc.this[0]: Destroying... [id=vpc-0e7f8e1665fd0e30f]
module.vpc.aws_vpc.this[0]: Destruction complete after 1s
aws_iam_role.eks_master_role: Destruction complete after 3s

Destroy complete! Resources: 37 destroyed.
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests$

~~~~







### Dia 25/02/2023

- Deletando a chave SSH "fernando-devops-20-02-2023":
fernando-devops-20-02-2023
Successfully deleted 1 key pairs



git filter-branch -f --index-filter 'git rm --cached --ignore-unmatch 09-eks-cluster-terraform-simples/.terraform/providers/registry.terraform.io/hashicorp/aws/3.76.1/linux_amd64/terraform-provider-aws_v3.76.1_x5'


git filter-branch -f --index-filter 'git rm --cached --ignore-unmatch 01-ekscluster-terraform-manifests/.terraform/providers/registry.terraform.io/hashicorp/aws/3.76.1/linux_amd64/terraform-provider-aws_v3.76.1_x5'





### - Configurar um projeto simples do EKS, sem o Bastion e outros recursos, na pasta 09.
- Configurar um projeto simples do EKS, sem o Bastion e outros recursos, na pasta 09.
- Deletando manifestos sobre Bastion
/home/fernando/cursos/terraform/eks-via-terraform-github-actions/09-eks-cluster-terraform-simples/c4-01-ec2bastion-variables.tf









----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

# PENDENTE
- Configurar um projeto simples do EKS, sem o Bastion e outros recursos, na pasta 01.
- Configurar o Gitignore para os arquivos Terraform.
- Configurar Terraform Cloud Free.
- Automatizar a criação da Role, Policy, atrelar policy, criação de RBAC para console, edição do ConfigMap.
  https://docs.aws.amazon.com/eks/latest/userguide/view-kubernetes-resources.html#view-kubernetes-resources-permissions
- Criar pipeline no Github Actions.
- Pipeline que faça o deploy de um EKS simples quando houver um PR para a branch "devops-eks-simples".
- Pipeline que faça o deploy de um EKS completo(com Bastion e Chave SSH), quando houver um PR para a branch "devops-eks-completo".
- Criar branch com a versão final testada e completa.
- Criar branch com a versão final testada e simples(sem Bastion).









### Dia 26/02/2023

- Configurar um projeto simples do EKS, sem o Bastion e outros recursos, na pasta 01.


- Configurar o Gitignore para os arquivos Terraform.
  519  git status
  520  git add .
  521  git commit -m "atualizando o Gitignore"
  522  git push






For a folder

git add -u
git reset -- main/*



 -u, --update
           Update the index just where it already has an entry matching <pathspec>. This removes as well as modifies index entries to match the working tree, but adds no new files.

           If no <pathspec> is given when -u option is used, all tracked files in the entire working tree are updated (old versions of Git used to limit the update to the current
           directory and its subdirectories).



01-eks-cluster-terraform-simples/.terraform





fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions$ git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   01-eks-cluster-terraform-simples/c1-versions.tf
        modified:   01-eks-cluster-terraform-simples/c2-01-generic-variables.tf
        modified:   01-eks-cluster-terraform-simples/c2-02-local-values.tf
        modified:   01-eks-cluster-terraform-simples/c3-01-vpc-variables.tf
        modified:   01-eks-cluster-terraform-simples/c3-02-vpc-module.tf
        modified:   01-eks-cluster-terraform-simples/c5-01-eks-variables.tf
        modified:   01-eks-cluster-terraform-simples/c5-02-eks-outputs.tf
        modified:   01-eks-cluster-terraform-simples/c5-06-eks-cluster.tf
        modified:   01-eks-cluster-terraform-simples/c5-07-eks-node-group-public.tf
        modified:   01-eks-cluster-terraform-simples/c5-08-eks-node-group-private.tf
        modified:   01-eks-cluster-terraform-simples/eks.auto.tfvars
        modified:   01-eks-cluster-terraform-simples/terraform.tfvars
        modified:   01-eks-cluster-terraform-simples/vpc.auto.tfvars

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        01-eks-cluster-terraform-simples/.terraform.lock.hcl
        01-eks-cluster-terraform-simples/.terraform/

no changes added to commit (use "git add" and/or "git commit -a")
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions$




git add -u
git reset -- 01-eks-cluster-terraform-simples/.terraform
git reset -- 01-eks-cluster-terraform-simples/.terraform/*





fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions$ git add -u
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions$ git reset -- 01-eks-cluster-terraform-simples/.terraform
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions$ git reset -- 01-eks-cluster-terraform-simples/.terraform/*
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions$
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions$
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions$
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions$ git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        modified:   01-eks-cluster-terraform-simples/c1-versions.tf
        modified:   01-eks-cluster-terraform-simples/c2-01-generic-variables.tf
        modified:   01-eks-cluster-terraform-simples/c2-02-local-values.tf
        modified:   01-eks-cluster-terraform-simples/c3-01-vpc-variables.tf
        modified:   01-eks-cluster-terraform-simples/c3-02-vpc-module.tf
        modified:   01-eks-cluster-terraform-simples/c5-01-eks-variables.tf
        modified:   01-eks-cluster-terraform-simples/c5-02-eks-outputs.tf
        modified:   01-eks-cluster-terraform-simples/c5-06-eks-cluster.tf
        modified:   01-eks-cluster-terraform-simples/c5-07-eks-node-group-public.tf
        modified:   01-eks-cluster-terraform-simples/c5-08-eks-node-group-private.tf
        modified:   01-eks-cluster-terraform-simples/eks.auto.tfvars
        modified:   01-eks-cluster-terraform-simples/terraform.tfvars
        modified:   01-eks-cluster-terraform-simples/vpc.auto.tfvars

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        01-eks-cluster-terraform-simples/.terraform.lock.hcl
        01-eks-cluster-terraform-simples/.terraform/

fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions$










- Efetuando apply


Plan: 31 to add, 0 to change, 0 to destroy.

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

Do you want to perform these actions in workspace "eks-via-terraform"?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes











----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

# PENDENTE
- Configurar um projeto simples do EKS, sem o Bastion e outros recursos, na pasta 01.
- Automatizar a criação da Role, Policy, atrelar policy, criação de RBAC para console, edição do ConfigMap.
  https://docs.aws.amazon.com/eks/latest/userguide/view-kubernetes-resources.html#view-kubernetes-resources-permissions
- Criar pipeline no Github Actions.
- Pipeline que faça o deploy de um EKS simples quando houver um PR para a branch "devops-eks-simples".
- Pipeline que faça o deploy de um EKS completo(com Bastion e Chave SSH), quando houver um PR para a branch "devops-eks-completo".
- Criar branch com a versão final testada e completa.
- Criar branch com a versão final testada e simples(sem Bastion).









- ERRO


╷
│ Error: error creating EKS Node Group (hr-stag-eksdemo1:hr-stag-eks-ng-public): InvalidParameterException: KeyPair fernando-devops-new-26-02-2023 not found
│ {
│   RespMetadata: {
│     StatusCode: 400,
│     RequestID: "f41c263f-9c92-4720-8b17-287b47872393"
│   },
│   ClusterName: "hr-stag-eksdemo1",
│   Message_: "KeyPair fernando-devops-new-26-02-2023 not found",
│   NodegroupName: "hr-stag-eks-ng-public"
│ }
│
│   with aws_eks_node_group.eks_ng_public,
│   on c5-07-eks-node-group-public.tf line 2, in resource "aws_eks_node_group" "eks_ng_public":
│    2: resource "aws_eks_node_group" "eks_ng_public" {
│
╵
Operation failed: failed running terraform apply (exit 1)
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/01-eks-cluster-terraform-simples$






- Comentando o bloco sobre chave SSH no arquivo:
/home/fernando/cursos/terraform/eks-via-terraform-github-actions/01-eks-cluster-terraform-simples/c5-07-eks-node-group-public.tf

  remote_access {
    ec2_ssh_key = "fernando-devops-new-26-02-2023"
  }














- Apply ocorreu em outra conta AWS



      - "us-east-1f",
    ] -> null
  - cluster_arn                        = "arn:aws:eks:us-east-1:816678621138:cluster/hr-stag-eksdemo1" -> null
  - cluster_certificate_authority_data = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJek1ESXlOakUxTURJMU5Gb1hEVE16TURJeU16RTFNREkxTkZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTWVkCmQ5amo4VnR2TjFHWlR1dWVYQ0Zwdlh4KzAxL2FheFBDbEhJNkNwOHBTZmpFYXhyYUk1MlJwbDgrSUlwZ3ZaREIKRUZqWXFtUlJJNkdCWDA0NjhvcUd4VGNzWnFoaFg0aFJ6WW9ZOWFibkVsME5LZi9rV3VUUzBGSW5hNUtmKzljUgpRamdla3VPZUZTeFV6MmZNa01SblUrWGF3R2Yvdkh2SlhmMGx6SnJqL1Z4REZxVUpxWVV4bmVFY3pDRG1zS3lPCkRnQXdQMEtLMm96RGZkalhkRVExcktDWFVOd0MyTzliTFZYYXVTMUc0ek1iUkRLaGQ2L282WFhlbktKL3NvRGMKOG5NRXJwODZSQXlLTnpvaCtDQ3c1RTlyU2xnL1ROZXhRYXhSeklkUlNhQUgvMjI3Z0l3Y1VoWkExTTBiQjZRSQplcDVlQU41YlRaRkF0K0twbmZNQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZGUEh6NmZOZ0JJNnFxQUhtMHZZaU52bUJXTmpNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRnFLa3hXL1NvbHNUWWJwMURjUAovcngzeXFYaEJsVUcyYmV5aHdyVHRKQy9OU1E5Z3Y5RUJlU29FQk9POEk4cHJJVUNMUGxGd1U3eGx2Y245K2JNClZiTGxYM0NtMEVOUHA5RzVhOU56OVVNMU9aQkdDQm04aFBVT0wxQm1HcTEzNjMrOURPVVRxeW1wL0tlVFB6V0UKM2wwaVVPSnlmTy9vM0JsMHVtS2Rod1E3UVI0bjB2WmtzTTBZanlFZG44a0ZaNW4wT1diR1ZQRnIveDBIa2prcwovUmN2T3hHbTN1U2Mwb0I3ejJvd1UvQTBRQ3IyRXd3NjZZVjRJd0YycVJrd2RxSHJWMXA2ZHBDRFFWRnh5U3JJCkc0Vks4TE0xYTgyL0wrU3NMSjVVekJDQlNXUEVlUlpHNmJDRnlGVXlqSVJJb2JwRkhSWUxoOWhBUFNobXdXK2MKRmdZPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==" -> null
  - cluster_endpoint                   = "https://EC06C9ACC3084FC82815C306CD4169D4.gr7.us-east-1.eks.amazonaws.com" -> null
  - cluster_iam_role_arn               = "arn:aws:iam::816678621138:role/hr-stag-eks-master-role" -> null
  - cluster_iam_role_name              = "hr-stag-eks-master-role" -> null
  - cluster_id                         = "hr-stag-eksdemo1" -> null
  - cluster_oidc_issuer_url            = "https://oidc.eks.us-east-1.amazonaws.com/id/EC06C9ACC3084FC82815C306CD4169D4" -> null
  - cluster_primary_security_group_id  = "sg-089dc9df2e29c41d9" -> null
  - cluster_version                    = "1.22" -> null
  - nat_public_ips                     = [
      - "52.204.54.74",
    ] -> null
  - node_group_public_arn              = "arn:aws:eks:us-east-1:816678621138:nodegroup/hr-stag-eksdemo1/hr-stag-eks-ng-public/d6c34725-80e3-de01-16ba-1927ffe2991b" -> null
  - node_group_public_id               = "hr-stag-eksdemo1:hr-stag-eks-ng-public" -> null
  - node_group_public_status           = "ACTIVE" -> null
  - node_group_public_version          = "1.22" -> null
  - private_subnets                    = [
      - "subnet-047164ac5c2415cfb",
      - "subnet-0a0af4947604cac47",
    ] -> null
  - public_subnets                     = [
      - "subnet-0c22f9b23d7e3f1db",
      - "subnet-0c2ea8dc8ea2df0d6",
    ] -> null




apsed]
aws_eks_node_group.eks_ng_public: Destruction complete after 8m22s
aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly: Destroying... [id=hr-stag-eks-nodegroup-role-20230226145655921000000002]
aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy: Destroying... [id=hr-stag-eks-nodegroup-role-20230226145655924400000003]
aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy: Destroying... [id=hr-stag-eks-nodegroup-role-20230226145655919200000001]
aws_eks_cluster.eks_cluster: Destroying... [id=hr-stag-eksdemo1]
aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy: Destruction complete after 0s
aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly: Destruction complete after 0s
aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy: Destruction complete after 0s
aws_iam_role.eks_nodegroup_role: Destroying... [id=hr-stag-eks-nodegroup-role]
aws_iam_role.eks_nodegroup_role: Destruction complete after 0s
aws_eks_cluster.eks_cluster: Still destroying... [id=hr-stag-eksdemo1, 10s elapsed]
aws_eks_cluster.eks_cluster: Still destroying... [id=hr-stag-eksdemo1, 20s elapsed]
aws_eks_cluster.eks_cluster: Still destroying... [id=hr-stag-eksdemo1, 30s elapsed]
aws_eks_cluster.eks_cluster: Still destroying... [id=hr-stag-eksdemo1, 40s elapsed]
aws_eks_cluster.eks_cluster: Still destroying... [id=hr-stag-eksdemo1, 50s elapsed]
aws_eks_cluster.eks_cluster: Still destroying... [id=hr-stag-eksdemo1, 1m0s elapsed]
aws_eks_cluster.eks_cluster: Still destroying... [id=hr-stag-eksdemo1, 1m10s elapsed]
aws_eks_cluster.eks_cluster: Destruction complete after 1m14s
aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy: Destroying... [id=hr-stag-eks-master-role-20230226145655930300000004]
aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController: Destroying... [id=hr-stag-eks-master-role-20230226145655933100000005]
module.vpc.aws_subnet.public[0]: Destroying... [id=subnet-0c22f9b23d7e3f1db]
module.vpc.aws_subnet.public[1]: Destroying... [id=subnet-0c2ea8dc8ea2df0d6]
aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController: Destruction complete after 0s
aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy: Destruction complete after 0s
aws_iam_role.eks_master_role: Destroying... [id=hr-stag-eks-master-role]
aws_iam_role.eks_master_role: Destruction complete after 0s
module.vpc.aws_subnet.public[1]: Destruction complete after 1s
module.vpc.aws_subnet.public[0]: Destruction complete after 1s
module.vpc.aws_vpc.this[0]: Destroying... [id=vpc-0e1032235a23e81d2]
module.vpc.aws_vpc.this[0]: Destruction complete after 0s

Apply complete! Resources: 0 added, 0 changed, 31 destroyed.

fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/01-eks-cluster-terraform-simples$





- Provável que tenha sido usada a chave:
fernandomjunior_accessKeys__2.csv
arn:aws:iam::816678621138:user/fernandomjunior
AKIA34JOWZ7JI3YJMTTK


- Como o backend está remoto, necessário ajustar variáveis no Terraform CLOUD:
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY


- Ajustando para:
fernandomullerjr8596__new_user_credentials.csv






│ Warning: Value for undeclared variable
│
│ The root module does not declare a variable named "AWS_SECRET_ACCESS_KEY"
│ but a value was found in file
│ "/home/tfc-agent/.tfc-agent/component/terraform/runs/run-uTfTZ6RTQfNWNzsC/terraform.tfvars".
│ If you meant to use this value, add a "variable" block to the
│ configuration.
│
│ To silence these warnings, use TF_VAR_... environment variables to provide
│ certain "global" settings to all configurations in your organization. To
│ reduce the verbosity of these warnings, use the -compact-warnings option.
╵
╷
│ Error: error configuring Terraform AWS Provider: no valid credential sources for Terraform AWS Provider found.
│
│ Please see https://registry.terraform.io/providers/hashicorp/aws
│ for more information about providing credentials.
│
│ Error: NoCredentialProviders: no valid providers in chain
│ caused by: EnvAccessKeyNotFound: failed to find credentials in the environment.
│ SharedCredsLoad: failed to load profile, .
│ EC2RoleRequestError: no EC2 instance role found
│ caused by: RequestError: send request failed
│ caused by: Get "http://169.254.169.254/latest/meta-data/iam/security-credentials/": context deadline exceeded (Client.Timeout exceeded while awaiting headers)
│
│
│   with provider["registry.terraform.io/hashicorp/aws"],
│   on c1-versions.tf line 13, in provider "aws":
│   13: provider "aws" {
│
╵
Operation failed: failed running terraform plan (exit 1)
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/01-eks-cluster-terraform-simples$







- Plan dando erro com novas chaves AWS no TF CLOUD

Terraform v1.1.5
on linux_amd64
Initializing plugins and modules...
╷
│ Warning: Value for undeclared variable
│
│ The root module does not declare a variable named "AWS_SECRET_ACCESS_KEY"
│ but a value was found in file
│ "/home/tfc-agent/.tfc-agent/component/terraform/runs/run-kk9Z8TcHaqUxc1rc/terraform.tfvars".
│ If you meant to use this value, add a "variable" block to the
│ configuration.
│
│ To silence these warnings, use TF_VAR_... environment variables to provide
│ certain "global" settings to all configurations in your organization. To
│ reduce the verbosity of these warnings, use the -compact-warnings option.
╵
╷
│ Error: error configuring Terraform AWS Provider: no valid credential sources for Terraform AWS Provider found.
│
│ Please see https://registry.terraform.io/providers/hashicorp/aws
│ for more information about providing credentials.
│
│ Error: NoCredentialProviders: no valid providers in chain
│ caused by: EnvAccessKeyNotFound: failed to find credentials in the environment.
│ SharedCredsLoad: failed to load profile, .
│ EC2RoleRequestError: no EC2 instance role found
│ caused by: RequestError: send request failed
│ caused by: Get "http://169.254.169.254/latest/meta-data/iam/security-credentials/": context deadline exceeded (Client.Timeout exceeded while awaiting headers)
│
│
│   with provider["registry.terraform.io/hashicorp/aws"],
│   on c1-versions.tf line 13, in provider "aws":
│   13: provider "aws" {
│
╵
Operation failed: failed running terraform plan (exit 1)
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/01-eks-cluster-terraform-simples$




# PENDENTE
- TSHOOT, - Plan dando erro com novas chaves AWS no TF CLOUD. Avaliar variável a nível de configuração no home, tf, cloud, .conf, etc
- Ver sobre conta AWS 816678621138 e o Billing dela. Avaliar desativação de chaves AWS ou não. Ver cartão associado.
- Configurar um projeto simples do EKS, sem o Bastion e outros recursos, na pasta 01.
- Automatizar a criação da Role, Policy, atrelar policy, criação de RBAC para console, edição do ConfigMap.
      https://docs.aws.amazon.com/eks/latest/userguide/view-kubernetes-resources.html#view-kubernetes-resources-permissions
- Criar pipeline no Github Actions.
- Pipeline que faça o deploy de um EKS simples quando houver um PR para a branch "devops-eks-simples".
- Pipeline que faça o deploy de um EKS completo(com Bastion e Chave SSH), quando houver um PR para a branch "devops-eks-completo".
- Criar branch com a versão final testada e completa.
- Criar branch com a versão final testada e simples(sem Bastion).





# Dia 05/03/2023

- TSHOOT, - Plan dando erro com novas chaves AWS no TF CLOUD. Avaliar variável a nível de configuração no home, tf, cloud, .conf, etc

- Coloquei as variáveis que existiam apenas no "Variable sets ", dentro do "Variables" em "Workspace variables" como Environment:
Key 	Value 	Category 	

AWS_ACCESS_KEY_ID

fernandomullerjr8596 - nova
	AKIATZSZP7M27OZBGERG 	env 	

AWS_SECRET_ACCESS_KEY

fernandomullerjr8596 - nova
Sensitive 


- Rodei o plan novamente, apesar do warning, fez o plan:

~~~~bash

│ Warning: Value for undeclared variable
│
│ The root module does not declare a variable named "AWS_SECRET_ACCESS_KEY"
│ but a value was found in file
│ "/home/tfc-agent/.tfc-agent/component/terraform/runs/run-i1E5RpujEiwLKiUT/terraform.tfvars".
│ If you meant to use this value, add a "variable" block to the
│ configuration.
│
│ To silence these warnings, use TF_VAR_... environment variables to provide
│ certain "global" settings to all configurations in your organization. To
│ reduce the verbosity of these warnings, use the -compact-warnings option.
╵
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/01-eks-cluster-terraform-simples$
~~~~





- Comentei o bloco no arquivo
/home/fernando/cursos/terraform/eks-via-terraform-github-actions/01-eks-cluster-terraform-simples/c1-versions.tf

~~~~h
# Terraform Provider Block
#provider "aws" {
#  region = var.aws_region
#
~~~~





shared_credentials_file - (Optional, Deprecated) Path to the shared credentials file. If not set and a profile is used, the default value is ~/.aws/credentials. Can also be set with the AWS_SHARED_CREDENTIALS_FILE environment variable.
shared_credentials_files - (Optional) List of paths to the shared credentials file. If not set and a profile is used, the default value is [~/.aws/credentials]. A single value can also be set with the AWS_SHARED_CREDENTIALS_FILE environment variable.



variable "AWS_SECRET_ACCESS_KEY" {
  default = ""
}

variable "AWS_ACCESS_KEY_ID" {
  default = ""
}





- Ver sobre conta AWS 816678621138 e o Billing dela. Avaliar desativação de chaves AWS ou não. Ver cartão associado.
chaves desativadas





# PENDENTE
- Configurar um projeto simples do EKS, sem o Bastion e outros recursos, na pasta 01.
- Automatizar a criação da Role, Policy, atrelar policy, criação de RBAC para console, edição do ConfigMap.
      https://docs.aws.amazon.com/eks/latest/userguide/view-kubernetes-resources.html#view-kubernetes-resources-permissions
- Criar pipeline no Github Actions.
- Pipeline que faça o deploy de um EKS simples quando houver um PR para a branch "devops-eks-simples".
- Pipeline que faça o deploy de um EKS completo(com Bastion e Chave SSH), quando houver um PR para a branch "devops-eks-completo".
- Criar branch com a versão final testada e completa.
- Criar branch com a versão final testada e simples(sem Bastion).










# Git - Efetuando Push
git status
git add -u
git reset -- 02-eks-via-blueprint/.terraform
git reset -- 02-eks-via-blueprint/.terraform*
git commit -m "Adicionando pasta 02-eks-via-blueprint"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status









# PENDENTE
- Avaliar uso de EKS-Blueprint ou EKS-explicito(manifestos).
- Configurar um projeto simples do EKS, sem o Bastion e outros recursos, na pasta 01.
- Automatizar a criação da Role, Policy, atrelar policy, criação de RBAC para console, edição do ConfigMap.
      https://docs.aws.amazon.com/eks/latest/userguide/view-kubernetes-resources.html#view-kubernetes-resources-permissions
- Criar pipeline no Github Actions.
- Pipeline que faça o deploy de um EKS simples quando houver um PR para a branch "devops-eks-simples".
- Pipeline que faça o deploy de um EKS completo(com Bastion e Chave SSH), quando houver um PR para a branch "devops-eks-completo".
- Criar branch com a versão final testada e completa.
- Criar branch com a versão final testada e simples(sem Bastion).











----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

# EKS Blueprint - Example: ArgoCD

/home/fernando/cursos/terraform/eks-via-terraform-github-actions/03-eks-via-blueprint-argocd


- Erro durante terraform init

~~~~bash

- eks.self_managed_node_group in .terraform/modules/eks/modules/self-managed-node-group
- eks.self_managed_node_group.user_data in .terraform/modules/eks/modules/_user_data
- eks_blueprints_kubernetes_addons in
Downloading registry.terraform.io/terraform-aws-modules/vpc/aws 3.19.0 for vpc...
- vpc in .terraform/modules/vpc
╷
│ Error: Unreadable module directory
│
│ Unable to evaluate directory symlink: lstat ../../modules: no such file or directory
╵

╷
│ Error: Failed to read module directory
│
│ Module directory  does not exist or cannot be read.
╵

╷
│ Error: Unreadable module directory
│
│ Unable to evaluate directory symlink: lstat ../../modules: no such file or directory
╵

╷
│ Error: Failed to read module directory
│
│ Module directory  does not exist or cannot be read.
╵

╷
│ Error: Unreadable module directory
│
│ Unable to evaluate directory symlink: lstat ../../modules: no such file or directory
╵

╷
│ Error: Failed to read module directory
│
│ Module directory  does not exist or cannot be read.
╵

fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/03-eks-via-blueprint-argocd$

~~~~








- Ajustando main.tf

DE:
module "eks_blueprints_kubernetes_addons" {
  source = "../../modules/kubernetes-addons"

PARA:
module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons"

 


- Testando novamente o Terraform init






# PENDENTE
- Seguir testando Blueprint de ArgoCD:
    https://github.com/aws-ia/terraform-aws-eks-blueprints/tree/main/examples/argocd
- Avaliar uso de EKS-Blueprint ou EKS-explicito(manifestos).
- Explorar questões do data que pega o usuário atual, para aplicar roles, arn, etc
- Ler artigo sobre Blueprint:
    https://medium.com/everything-full-stack/iac-gitops-with-eks-blueprints-7a28ad1f702a
- Automatizar a criação da Role, Policy, atrelar policy, criação de RBAC para console, edição do ConfigMap.
      https://docs.aws.amazon.com/eks/latest/userguide/view-kubernetes-resources.html#view-kubernetes-resources-permissions
- Criar pipeline no Github Actions.
- Pipeline que faça o deploy de um EKS simples quando houver um PR para a branch "devops-eks-simples".
- Pipeline que faça o deploy de um EKS completo(com Bastion e Chave SSH), quando houver um PR para a branch "devops-eks-completo".
- Criar branch com a versão final testada e completa.
- Criar branch com a versão final testada e simples(sem Bastion).







03-eks-via-blueprint-argocd
Your current user or role does not have access to Kubernetes objects on this EKS cluster


aws-ebs-csi-driver
Add-on detailsInfo
Status
Degraded

Health issues (1)
Issue type
Description
	
Affected resources
InsufficientNumberOfReplicas	The add-on is unhealthy because it doesn't have the desired number of replicas.






# PENDENTE
- Seguir testando Blueprint de ArgoCD:
    https://github.com/aws-ia/terraform-aws-eks-blueprints/tree/main/examples/argocd
    ocorreu erro no cluster "03-eks-via-blueprint-argocd": Your current user or role does not have access to Kubernetes objects on this EKS cluster
- Avaliar uso de EKS-Blueprint ou EKS-explicito(manifestos).
- Explorar questões do data que pega o usuário atual, para aplicar roles, arn, etc
- Ler artigo sobre Blueprint:
    https://medium.com/everything-full-stack/iac-gitops-with-eks-blueprints-7a28ad1f702a
- Automatizar a criação da Role, Policy, atrelar policy, criação de RBAC para console, edição do ConfigMap.
      https://docs.aws.amazon.com/eks/latest/userguide/view-kubernetes-resources.html#view-kubernetes-resources-permissions
- Criar pipeline no Github Actions.
- Pipeline que faça o deploy de um EKS simples quando houver um PR para a branch "devops-eks-simples".
- Pipeline que faça o deploy de um EKS completo(com Bastion e Chave SSH), quando houver um PR para a branch "devops-eks-completo".
- Criar branch com a versão final testada e completa.
- Criar branch com a versão final testada e simples(sem Bastion).

