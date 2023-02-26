

----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

# Git - Efetuando Push
git status
git add .
git commit -m "Projeto - eks-via-terraform-github-actions"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status




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




----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

# PENDENTE
- Configurar Terraform Cloud Free.
- Criar branch com a versão final testada e completa.
- Criar branch com a versão final testada e simples(sem Bastion).
- Automatizar a criação da Role, Policy, atrelar policy, criação de RBAC para console, edição do ConfigMap.
  https://docs.aws.amazon.com/eks/latest/userguide/view-kubernetes-resources.html#view-kubernetes-resources-permissions
- Criar pipeline no Github Actions.