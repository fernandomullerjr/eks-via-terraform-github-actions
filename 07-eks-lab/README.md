

# 07-eks-lab

- Projeto usando eks-blueprint
https://catalog.workshops.aws/eks-blueprints-terraform/en-US/030-provision-eks-cluster/1-create-a-terraform-project



# RESUMO
terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks_blueprints -auto-approve
terraform apply -auto-approve

terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve





## VPC

https://catalog.workshops.aws/eks-blueprints-terraform/en-US/030-provision-eks-cluster/2-create-vpc-and-subnets
<https://catalog.workshops.aws/eks-blueprints-terraform/en-US/030-provision-eks-cluster/2-create-vpc-and-subnets>

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

~~~~BASH
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
~~~~




- ajustando:
/home/fernando/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab/main.tf


DE:

~~~~h

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.16.0"

  name = local.name
  cidr = local.vpc_cidr

  azs  = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]

  enable_nat_gateway   = true
  create_igw           = true
  enable_dns_hostnames = true
  single_nat_gateway   = true

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "\${local.name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "\${local.name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "\${local.name}-default" }  

  public_subnet_tags = {
    "kubernetes.io/cluster/\${local.name}" = "shared"
    "kubernetes.io/role/elb"              = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/\${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = "1"
  }

    tags = local.tags
}

~~~~



PARA:

~~~~h

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.16.0"

  name = local.name
  cidr = local.vpc_cidr

  azs  = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]

  enable_nat_gateway   = true
  create_igw           = true
  enable_dns_hostnames = true
  single_nat_gateway   = true

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "\$${local.name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "\$${local.name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "\$${local.name}-default" }  

  public_subnet_tags = {
    "kubernetes.io/cluster/\$${local.name}" = "shared"
    "kubernetes.io/role/elb"              = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/\$${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = "1"
  }

    tags = local.tags
}

~~~~














- Segue com erro.





- Ajustando novamente:
/home/fernando/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab/main.tf

Removida a barra invertida e o cifrão adicional, deixando "simples" a interpolação

PARA:

~~~~h

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.16.0"

  name = local.name
  cidr = local.vpc_cidr

  azs  = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]

  enable_nat_gateway   = true
  create_igw           = true
  enable_dns_hostnames = true
  single_nat_gateway   = true

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${local.name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${local.name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.name}-default" }  

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/elb"              = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = "1"
  }

    tags = local.tags
}

~~~~




- OK, agora o terraform init funcionou:

~~~~BASH
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab$ terraform init
Initializing modules...
Downloading registry.terraform.io/terraform-aws-modules/vpc/aws 3.16.0 for vpc...
- vpc in .terraform/modules/vpc

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching ">= 3.72.0, >= 3.73.0"...
- Finding hashicorp/kubernetes versions matching ">= 2.10.0"...
- Finding hashicorp/helm versions matching ">= 2.4.1"...
- Finding gavinbunney/kubectl versions matching ">= 1.14.0"...
- Installing hashicorp/aws v4.58.0...
- Installed hashicorp/aws v4.58.0 (signed by HashiCorp)
- Installing hashicorp/kubernetes v2.18.1...
- Installed hashicorp/kubernetes v2.18.1 (signed by HashiCorp)
- Installing hashicorp/helm v2.9.0...
- Installed hashicorp/helm v2.9.0 (signed by HashiCorp)
- Installing gavinbunney/kubectl v1.14.0...
- Installed gavinbunney/kubectl v1.14.0 (self-signed, key ID AD64217B5ADD572F)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab$

~~~~








# The auto approve flag avoids you having to confirm you want to provision resources.
terraform apply -auto-approve

~~~~bash
module.vpc.aws_nat_gateway.this[0]: Creation complete after 1m46s [id=nat-05c9aa7f075f0911f]
module.vpc.aws_route.private_nat_gateway[0]: Creating...
module.vpc.aws_route.private_nat_gateway[0]: Creation complete after 2s [id=r-rtb-03d9d3c4bf714f3e81080289494]

Apply complete! Resources: 23 added, 0 changed, 0 destroyed.

Outputs:

vpc_id = "vpc-0cb7025b568a7efea"
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab$
~~~~







- Seguindo.

https://catalog.workshops.aws/eks-blueprints-terraform/en-US/030-provision-eks-cluster/3-provision-cluster
<https://catalog.workshops.aws/eks-blueprints-terraform/en-US/030-provision-eks-cluster/3-provision-cluster>




# Provision EKS Cluster with Managed Node Group
Important
We heavily rely on Terraform modules in the workshop you can read more about them here 
Before we use the EKS Blueprints for Terraform modules 

, we need to add some provider-specific configuration to our main.tf

In this step, we are going to add the EKS blueprint core module and configure it, including the EKS managed node group. From the code below you can see that we are pinning the main EKS Blueprint module to v4.21.0 

which corresponds to the GitHub repository release Tag. It is a good practice to lock-in all your modules to a given tried and tested version.

Please add the following (copy/paste) at the top of your main.tf right above the "vpc" module definition.

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
provider "kubernetes" {
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

provider "kubectl" {
  apply_retry_count      = 10
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
  load_config_file       = false
  token                  = data.aws_eks_cluster_auth.this.token
}

module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.21.0"

  cluster_name    = local.name

  # EKS Cluster VPC and Subnet mandatory config
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  # EKS CONTROL PLANE VARIABLES
  cluster_version = local.cluster_version

  # List of Additional roles admin in the cluster
  # Comment this section if you ARE NOT at an AWS Event, as the TeamRole won't exist on your site, or replace with any valid role you want
  map_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TeamRole"
      username = "ops-role" # The user name within Kubernetes to map to the IAM role
      groups   = ["system:masters"] # A list of groups within Kubernetes to which the role is mapped; Checkout K8s Role and Rolebindings
    }
  ]

  # EKS MANAGED NODE GROUPS
  managed_node_groups = {
    mg_5 = {
      node_group_name = local.node_group_name
      instance_types  = ["m5.xlarge"]
      subnet_ids      = module.vpc.private_subnets
    }
  }

  tags = local.tags
}

Now that we have our cluster definition, we want to add a new output that will have the kubectl command for us to add a new entry to our kubeconfig in order to connect to the cluster. Please add the following to the outputs.tf

1
2
3
4
output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = module.eks_blueprints.configure_kubectl
}

We can also declare additionals datas. Add thoses at the end of data.tf file.

1
2
3
4
5
6
7
data "aws_eks_cluster" "cluster" {
  name = module.eks_blueprints.eks_cluster_id
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks_blueprints.eks_cluster_id
}

Important
Don't forget to save the cloud9 files as auto-save is not enabled by default.

Next, execute the following commands in your terminal so that we can add the EKS Blueprints Terraform Module.

1
2
# we need to do this again, since we added a new module.
terraform init

View Terraform Output

1
2
# Always a good practice to use a dry-run command
terraform plan

1
2
3
# then provision our EKS cluster
# the auto approve flag avoids you having to confirm you want to provision resources.
terraform apply -auto-approve







- Plan:

Plan: 32 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + configure_kubectl = (known after apply)






- Aplicado, apply:

~~~~bash

module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_iam_instance_profile.managed_ng[0]: Creation complete after 1s [id=eks-lab-managed-ondemand]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Creating...
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [10s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [20s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [30s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [40s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [50s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [1m0s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [1m10s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [1m20s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [1m30s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [1m40s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Creation complete after 1m49s [id=eks-lab:managed-ondemand-20230315020600171000000009]

Apply complete! Resources: 32 added, 0 changed, 0 destroyed.

Outputs:

configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-0cb7025b568a7efea"
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab$

~~~~
















# Add Platform and Application Teams

https://catalog.workshops.aws/eks-blueprints-terraform/en-US/030-provision-eks-cluster/4-add-platform-and-dev-teams
<https://catalog.workshops.aws/eks-blueprints-terraform/en-US/030-provision-eks-cluster/4-add-platform-and-dev-teams>

Add Platform Team

The first thing we need to do, is add the Platform Team definition to our main.tf in the module eks_blueprints. This is the team that manages the EKS cluster provisioning.

Copy the platform team definition

1
2
3
4
5
6
7
  platform_teams = {
    admin = {
      users = [
        data.aws_caller_identity.current.arn
      ]
    }
  }

And paste it in the eks_blueprints module in main.tf as shown below

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
# Add the flagged code in this eks_blueprints module
# or replace all the module you created with te code below
#....
module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.21.0"

  cluster_name    = local.name

  # EKS Cluster VPC and Subnet mandatory config
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  # EKS CONTROL PLANE VARIABLES
  cluster_version = local.cluster_version

  # List of Additional roles admin in the cluster
  # Comment this section if you ARE NOT at an AWS Event, as the TeamRole won't exist on your site, or replace with any valid role you want
  map_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TeamRole"
      username = "ops-role"         # The user name within Kubernetes to map to the IAM role
      groups   = ["system:masters"] # A list of groups within Kubernetes to which the role is mapped; Checkout K8s Role and Rolebindings
    }
  ]

  # EKS MANAGED NODE GROUPS
  managed_node_groups = {
    mg_5 = {
      node_group_name = local.node_group_name
      instance_types  = ["m5.xlarge"]
      subnet_ids      = module.vpc.private_subnets
    }
  }

  # --> Paste the code here
  platform_teams = {
    admin = {
      users = [
        data.aws_caller_identity.current.arn
      ]
    }
  }
  # <-- End of new code

  tags = local.tags
}

This will create a dedicated role arn:aws:iam::0123456789:role/eks-blueprint-admin-access that will allow you to managed the cluster as administrator.

It also define which existing users/roles will be allowed to assume this role via the users parameter where you can provide a list of IAM arns. The new role is also configured in the EKS Configmap to allow authentication.
Add Riker Team EKS Tenant

Our next step is to define a Development Team in the EKS Platform as a Tenant. To do that, we add the following section to the main.tf

Under the platform team definition we add the following. If you have specific IAM Roles you would like to add to the team definition, you can do so in the users array which expects the IAM Role ARN.
Quotas are also enabled as shown below. Deploying resources without CPU or Memory limits will fail.

Add code below after the platform_teams we just added in eks_blueprints module

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
  application_teams = {
    team-riker = {
      "labels" = {
        "appName"     = "riker-team-app",
        "projectName" = "project-riker",
        "environment" = "dev",
        "domain"      = "example",
        "uuid"        = "example",
        "billingCode" = "example",
        "branch"      = "example"
      }
      "quota" = {
        "requests.cpu"    = "10",
        "requests.memory" = "20Gi",
        "limits.cpu"      = "30",
        "limits.memory"   = "50Gi",
        "pods"            = "15",
        "secrets"         = "10",
        "services"        = "10"
      }
      ## Manifests Example: we can specify a directory with kubernetes manifests that can be automatically applied in the team-riker namespace.
      manifests_dir = "./kubernetes/team-riker"
      users         = [data.aws_caller_identity.current.arn]
    }
  }

This will create a dedicated role arn:aws:iam::0123456789:role/eks-blueprint-team-riker-access that will allow you to managed the Team Riker authentication in EKS. The created IAM role will also be configured in the EKS Configmap.

The Team Riker being created is in fact a Kubernetes namespace with associated kubernetes RBAC and quotas, in this case team-riker. You can adjust the labels and quotas to values appropriate to the team you are adding. EKS

We are also using the manifest_dir directory that allow you to install specific kubernetes manifests at the namespace creation time. You can bootstrap the namespace with dedicated network policies rules, or anything that you need.

    Blueprint chooses to use namespaces and resource quotas to isolate application teams from each others. We can also add additional security policy enforcements and Network segreagation by applying additional kubernetes manifests when creating the teams namespaces.

We are going to create a default limit range that will inject default resources/limits to our pods if they where not defined

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
mkdir -p kubernetes/team-riker
cat << EOF > kubernetes/team-riker/limit-range.yaml
apiVersion: 'v1'
kind: 'LimitRange'
metadata:
  name: 'resource-limits'
  namespace: team-riker
spec:
  limits:
    - type: 'Container'
      max:
        cpu: '2'
        memory: '1Gi'
      min:
        cpu: '50m'
        memory: '4Mi'
      default:
        cpu: '300m'
        memory: '200Mi'
      defaultRequest:
        cpu: '200m'
        memory: '100Mi'
      maxLimitRequestRatio:
        cpu: '10'

EOF

Important
Don't forget to save the cloud9 file as auto-save is not enabled by default.

Now using the Terraform CLI, update the resources in AWS using the cli, note the -auto-approve flag that skips user approval to deploy changes without having to type “yes” as a confirmation to provision resources.

1
2
# Always a good practice to use a dry-run command
terraform plan

1
2
# apply changes to provision the Platform Team
terraform apply -auto-approve

There are several resources created when you onboard a team. including a Kubernetes Service Account created for the team. To view a full list, you can execute terraform state list and you should see resources similar to the ones shown below

1
terraform state list module.eks_blueprints.module.aws_eks_teams

1
2
3
4
5
6
7
8
9
10
11
12
13
# ommited lines for brevity

...
module.eks_blueprints.module.aws_eks_teams[0].aws_iam_role.team_access["team-riker"]
module.eks_blueprints.module.aws_eks_teams[0].aws_iam_role.team_sa_irsa["team-riker"]
module.eks_blueprints.module.aws_eks_teams[0].kubernetes_cluster_role.team["team-riker"]
module.eks_blueprints.module.aws_eks_teams[0].kubernetes_cluster_role_binding.team["team-riker"]
module.eks_blueprints.module.aws_eks_teams[0].kubernetes_namespace.team["team-riker"]
module.eks_blueprints.module.aws_eks_teams[0].kubernetes_resource_quota.team_compute_quota["team-riker"]
module.eks_blueprints.module.aws_eks_teams[0].kubernetes_resource_quota.team_object_quota["team-riker"]
module.eks_blueprints.module.aws_eks_teams[0].kubernetes_role.team["team-riker"]
module.eks_blueprints.module.aws_eks_teams[0].kubernetes_role_binding.team["team-riker"]
module.eks_blueprints.module.aws_eks_teams[0].kubernetes_service_account.team["team-riker"]

You can see in more detailed in the terraform state what AWS resources were created with our team module. For example you can see the platform team details:

1
terraform state show 'module.eks_blueprints.module.aws_eks_teams[0].aws_iam_role.platform_team["admin"]'

# module.eks_blueprints.module.aws_eks_teams[0].aws_iam_role.platform_team["admin"]:
resource "aws_iam_role" "platform_team" {
    arn                   = "arn:aws:iam::0123456789:role/eks-blueprint-admin-access"
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        AWS = [
                            "arn:aws:sts::0123456789:assumed-role/eks-blueprints-for-terraform-workshop-admin/i-09e1d15b60696663c",
                            "arn:aws:iam::0123456789:role/TeamRole",
                        ]
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    create_date           = "2022-06-15T08:39:04Z"
    force_detach_policies = false
    id                    = "eks-blueprint-admin-access"
    managed_policy_arns   = [
        "arn:aws:iam::0123456789:policy/eks-blueprint-PlatformTeamEKSAccess",
    ]
    max_session_duration  = 3600
    name                  = "eks-blueprint-admin-access"
    path                  = "/"
    tags                  = {
        "Blueprint"  = "eks-blueprint"
        "GithubRepo" = "github.com/aws-ia/terraform-aws-eks-blueprints"
    }
    tags_all              = {
        "Blueprint"  = "eks-blueprint"
        "GithubRepo" = "github.com/aws-ia/terraform-aws-eks-blueprints"
    }
    unique_id             = "AROA6NAAL5J5PF2ZPWHJP"

    inline_policy {}
}

Let's see how we can leverage the roles associated with our created Teams, in the next section.


















## PARCIAL

- Efetuando plan, após ter aplicado somente estre trecho ao main.tf:


  # teams
  platform_teams = {
    admin = {
      users = [
        data.aws_caller_identity.current.arn
      ]
    }
  }


─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  ~ update in-place
 <= read (data resources)

Terraform will perform the following actions:

  # module.eks_blueprints.kubernetes_config_map.aws_auth[0] will be updated in-place
  ~ resource "kubernetes_config_map" "aws_auth" {
      ~ data        = {
          ~ "mapRoles"    = <<-EOT
                - "groups":
                  - "system:bootstrappers"
                  - "system:nodes"
                  "rolearn": "arn:aws:iam::261106957109:role/eks-lab-managed-ondemand"
                  "username": "system:node:{{EC2PrivateDNSName}}"
                - "groups":
                  - "system:masters"
              +   "rolearn": "arn:aws:iam::261106957109:role/eks-lab-admin-access"
              +   "username": "admin"
              + - "groups":
              +   - "system:masters"
                  "rolearn": "arn:aws:iam::261106957109:role/TeamRole"
                  "username": "ops-role"
            EOT
            # (2 unchanged elements hidden)
        }
        id          = "kube-system/aws-auth"
        # (2 unchanged attributes hidden)

        # (1 unchanged block hidden)
    }

  # module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].data.aws_iam_policy_document.managed_ng_assume_role_policy will be read during apply
  # (config refers to values not yet known)
 <= data "aws_iam_policy_document" "managed_ng_assume_role_policy"  {
      ~ id      = "3778018924" -> (known after apply)
      ~ json    = jsonencode(
            {
              - Statement = [
                  - {
                      - Action    = "sts:AssumeRole"
                      - Effect    = "Allow"
                      - Principal = {
                          - Service = "ec2.amazonaws.com"
                        }
                      - Sid       = "EKSWorkerAssumeRole"
                    },
                ]
              - Version   = "2012-10-17"
            }
        ) -> (known after apply)
      - version = "2012-10-17" -> null

      ~ statement {
          - effect        = "Allow" -> null
          - not_actions   = [] -> null
          - not_resources = [] -> null
          - resources     = [] -> null
            # (2 unchanged attributes hidden)

            # (1 unchanged block hidden)
        }
    }

  # module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_iam_role.managed_ng[0] will be updated in-place
  ~ resource "aws_iam_role" "managed_ng" {
      ~ assume_role_policy    = jsonencode(
            {
              - Statement = [
                  - {
                      - Action    = "sts:AssumeRole"
                      - Effect    = "Allow"
                      - Principal = {
                          - Service = "ec2.amazonaws.com"
                        }
                      - Sid       = "EKSWorkerAssumeRole"
                    },
                ]
              - Version   = "2012-10-17"
            }
        ) -> (known after apply)
        id                    = "eks-lab-managed-ondemand"
        name                  = "eks-lab-managed-ondemand"
        tags                  = {
            "Blueprint"  = "eks-lab"
            "GithubRepo" = "github.com/aws-ia/terraform-aws-eks-blueprints"
        }
        # (9 unchanged attributes hidden)
    }

  # module.eks_blueprints.module.aws_eks_teams[0].aws_iam_policy.platform_team_eks_access[0] will be created
  + resource "aws_iam_policy" "platform_team_eks_access" {
      + arn         = (known after apply)
      + description = "Platform Team EKS Console Access"
      + id          = (known after apply)
      + name        = "eks-lab-PlatformTeamEKSAccess"
      + path        = "/"
      + policy      = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "ssm:GetParameter",
                          + "eks:ListUpdates",
                          + "eks:ListNodegroups",
                          + "eks:ListFargateProfiles",
                          + "eks:ListClusters",
                          + "eks:DescribeNodegroup",
                          + "eks:DescribeCluster",
                          + "eks:AccessKubernetesApi",
                        ]
                      + Effect   = "Allow"
                      + Resource = "arn:aws:eks:us-east-1:261106957109:cluster/eks-lab"
                      + Sid      = "AllowPlatformTeamEKSAccess"
                    },
                  + {
                      + Action   = "eks:ListClusters"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "AllowListClusters"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + policy_id   = (known after apply)
      + tags        = {
          + "Blueprint"  = "eks-lab"
          + "GithubRepo" = "github.com/aws-ia/terraform-aws-eks-blueprints"
        }
      + tags_all    = {
          + "Blueprint"  = "eks-lab"
          + "GithubRepo" = "github.com/aws-ia/terraform-aws-eks-blueprints"
        }
    }

  # module.eks_blueprints.module.aws_eks_teams[0].aws_iam_role.platform_team["admin"] will be created
  + resource "aws_iam_role" "platform_team" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + AWS = [
                              + "arn:aws:iam::261106957109:user/fernandomullerjr8596",
                            ]
                        }
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "eks-lab-admin-access"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags                  = {
          + "Blueprint"  = "eks-lab"
          + "GithubRepo" = "github.com/aws-ia/terraform-aws-eks-blueprints"
        }
      + tags_all              = {
          + "Blueprint"  = "eks-lab"
          + "GithubRepo" = "github.com/aws-ia/terraform-aws-eks-blueprints"
        }
      + unique_id             = (known after apply)

      + inline_policy {
          + name   = (known after apply)
          + policy = (known after apply)
        }
    }

Plan: 2 to add, 2 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab$







- Aplicado


Plan: 2 to add, 2 to change, 0 to destroy.
module.eks_blueprints.module.aws_eks_teams[0].aws_iam_policy.platform_team_eks_access[0]: Creating...
module.eks_blueprints.kubernetes_config_map.aws_auth[0]: Modifying... [id=kube-system/aws-auth]
module.eks_blueprints.kubernetes_config_map.aws_auth[0]: Modifications complete after 1s [id=kube-system/aws-auth]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].data.aws_iam_policy_document.managed_ng_assume_role_policy: Reading... [id=3778018924]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].data.aws_iam_policy_document.managed_ng_assume_role_policy: Read complete after 0s [id=3778018924]
module.eks_blueprints.module.aws_eks_teams[0].aws_iam_policy.platform_team_eks_access[0]: Creation complete after 1s [id=arn:aws:iam::261106957109:policy/eks-lab-PlatformTeamEKSAccess]
module.eks_blueprints.module.aws_eks_teams[0].aws_iam_role.platform_team["admin"]: Creating...
module.eks_blueprints.module.aws_eks_teams[0].aws_iam_role.platform_team["admin"]: Creation complete after 1s [id=eks-lab-admin-access]

Apply complete! Resources: 2 added, 1 changed, 0 destroyed.

Outputs:

configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-0cb7025b568a7efea"
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab$













- Mesmo assim, ocorre o erro:

Your current user or role does not have access to Kubernetes objects on this EKS cluster



fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab$ aws eks --region us-east-1 update-kubeconfig --name eks-lab
Added new context arn:aws:eks:us-east-1:261106957109:cluster/eks-lab to /home/fernando/.kube/config
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab$ kubectl get configmap -A
NAMESPACE         NAME                                 DATA   AGE
default           kube-root-ca.crt                     1      12m
kube-node-lease   kube-root-ca.crt                     1      12m
kube-public       kube-root-ca.crt                     1      12m
kube-system       aws-auth                             3      7m32s
kube-system       coredns                              1      12m
kube-system       cp-vpc-resource-controller           0      12m
kube-system       eks-certificates-controller          0      12m
kube-system       extension-apiserver-authentication   6      12m
kube-system       kube-proxy                           1      12m
kube-system       kube-proxy-config                    1      12m
kube-system       kube-root-ca.crt                     1      12m
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab$ kubectl describe configmap aws-auth -n kube-system
Name:         aws-auth
Namespace:    kube-system
Labels:       app.kubernetes.io/created-by=terraform-aws-eks-blueprints
              app.kubernetes.io/managed-by=terraform-aws-eks-blueprints
Annotations:  <none>

Data
====
mapAccounts:
----
[]

mapRoles:
----
- "groups":
  - "system:bootstrappers"
  - "system:nodes"
  "rolearn": "arn:aws:iam::261106957109:role/eks-lab-managed-ondemand"
  "username": "system:node:{{EC2PrivateDNSName}}"
- "groups":
  - "system:masters"
  "rolearn": "arn:aws:iam::261106957109:role/eks-lab-admin-access"
  "username": "admin"
- "groups":
  - "system:masters"
  "rolearn": "arn:aws:iam::261106957109:role/TeamRole"
  "username": "ops-role"

mapUsers:
----
[]


BinaryData
====

Events:  <none>
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab$ ^C




# PENDENTE


- AJUSTANDO
/home/fernando/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab/main.tf

https://aws-ia.github.io/terraform-aws-eks-blueprints/node-groups/

 # List of map_users
  map_users = [
    {
      userarn  = "arn:aws:iam::<aws-account-id>:user/<username>"      # The ARN of the IAM user to add.
      username = "opsuser"                                            # The user name within Kubernetes to map to the IAM role
      groups   = ["system:masters"]                                   # A list of groups within Kubernetes to which the role is mapped; Checkout K8s Role and Rolebindings
    }
  ]



- eDITADO:


  map_users = [
    {
      userarn  = data.aws_caller_identity.current.arn     # The ARN of the IAM user to add.
      username = "opsuser"                                            # The user name within Kubernetes to map to the IAM role
      groups   = ["system:masters"]                                   # A list of groups within Kubernetes to which the role is mapped; Checkout K8s Role and Rolebindings
    }
  ]



- Plan


Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place
 <= read (data resources)

Terraform will perform the following actions:

  # module.eks_blueprints.kubernetes_config_map.aws_auth[0] will be updated in-place
  ~ resource "kubernetes_config_map" "aws_auth" {
      ~ data        = {
          ~ "mapUsers"    = <<-EOT
              - []
              + - "groups":
              +   - "system:masters"
              +   "userarn": "arn:aws:iam::261106957109:user/fernandomullerjr8596"
              +   "username": "opsuser"
            EOT
            # (2 unchanged elements hidden)
        }
        id          = "kube-system/aws-auth"
        # (2 unchanged attributes hidden)

        # (1 unchanged block hidden)
    }

  # module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].data.aws_iam_policy_document.managed_ng_assume_role_policy will be read during apply
  # (config refers to values not yet known)
 <= data "aws_iam_policy_document" "managed_ng_assume_role_policy"  {
      ~ id      = "3778018924" -> (known after apply)
      ~ json    = jsonencode(
            {
              - Statement = [
                  - {
                      - Action    = "sts:AssumeRole"
                      - Effect    = "Allow"
                      - Principal = {
                          - Service = "ec2.amazonaws.com"
                        }
                      - Sid       = "EKSWorkerAssumeRole"
                    },
                ]
              - Version   = "2012-10-17"
            }
        ) -> (known after apply)
      - version = "2012-10-17" -> null

      ~ statement {
          - effect        = "Allow" -> null
          - not_actions   = [] -> null
          - not_resources = [] -> null
          - resources     = [] -> null
            # (2 unchanged attributes hidden)

            # (1 unchanged block hidden)
        }
    }

  # module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_iam_role.managed_ng[0] will be updated in-place
  ~ resource "aws_iam_role" "managed_ng" {
      ~ assume_role_policy    = jsonencode(
            {
              - Statement = [
                  - {
                      - Action    = "sts:AssumeRole"
                      - Effect    = "Allow"
                      - Principal = {
                          - Service = "ec2.amazonaws.com"
                        }
                      - Sid       = "EKSWorkerAssumeRole"
                    },
                ]
              - Version   = "2012-10-17"
            }
        ) -> (known after apply)
        id                    = "eks-lab-managed-ondemand"
        name                  = "eks-lab-managed-ondemand"
        tags                  = {
            "Blueprint"  = "eks-lab"
            "GithubRepo" = "github.com/aws-ia/terraform-aws-eks-blueprints"
        }
        # (9 unchanged attributes hidden)
    }

Plan: 0 to add, 2 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab$





- Aplicado


Plan: 0 to add, 2 to change, 0 to destroy.
module.eks_blueprints.kubernetes_config_map.aws_auth[0]: Modifying... [id=kube-system/aws-auth]
module.eks_blueprints.kubernetes_config_map.aws_auth[0]: Modifications complete after 1s [id=kube-system/aws-auth]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].data.aws_iam_policy_document.managed_ng_assume_role_policy: Reading... [id=3778018924]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].data.aws_iam_policy_document.managed_ng_assume_role_policy: Read complete after 0s [id=3778018924]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-0cb7025b568a7efea"
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab$






- Trecho do map user atual, que não funcionou:

~~~~h
 # List of map_users
  map_users = [
    {
      userarn  = data.aws_caller_identity.current.arn     # The ARN of the IAM user to add.
      username = "opsuser"                                            # The user name within Kubernetes to map to the IAM role
      groups   = ["system:masters"]                                   # A list of groups within Kubernetes to which the role is mapped; Checkout K8s Role and Rolebindings
    }
  ]
~~~~


- Segue com erro:

Your current user or role does not have access to Kubernetes objects on this EKS cluster
This may be due to the current user or role not having Kubernetes RBAC permissions to describe cluster resources or not having an entry in the cluster’s auth config map.Learn more 




We can now safely delete our EKS Cluster

1
terraform destroy -target=module.eks_blueprints -auto-approve

View Terraform Output

Next, delete the remaining modules from the main.tf
Finally we can delete VPC and all remaining services

1
terraform destroy -auto-approve










# Dia 16/03/2023

terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks_blueprints -auto-approve
terraform apply -auto-approve

terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve



~~~~bash


Plan: 34 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + configure_kubectl = (known after apply)
module.eks_blueprints.module.aws_eks.aws_security_group.cluster[0]: Creating...
module.eks_blueprints.module.aws_eks.aws_security_group.node[0]: Creating...
module.eks_blueprints.module.kms[0].aws_kms_key.this: Creating...
module.eks_blueprints.module.aws_eks.aws_iam_role.this[0]: Creating...
module.eks_blueprints.module.aws_eks.aws_iam_role.this[0]: Creation complete after 2s [id=eks-lab-cluster-role]
module.eks_blueprints.module.aws_eks.aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"]: Creating...
module.eks_blueprints.module.aws_eks.aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]: Creating...
module.eks_blueprints.module.aws_eks.aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"]: Creation complete after 0s [id=eks-lab-cluster-role-20230317013929736600000003]
module.eks_blueprints.module.aws_eks.aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]: Creation complete after 0s [id=eks-lab-cluster-role-20230317013929940200000004]
module.eks_blueprints.module.aws_eks.aws_security_group.node[0]: Creation complete after 4s [id=sg-01cae2ddc371e80cf]
module.eks_blueprints.module.aws_eks.aws_security_group.cluster[0]: Creation complete after 4s [id=sg-069a99ab54f0fa83d]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["egress_nodes_443"]: Creating...
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_ntp_udp"]: Creating...
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["ingress_nodes_443"]: Creating...
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["egress_nodes_kubelet"]: Creating...
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_cluster_kubelet"]: Creating...
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_cluster_443"]: Creating...
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_self_coredns_udp"]: Creating...
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_cluster_443"]: Creating...
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_self_coredns_udp"]: Creating...
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_ntp_udp"]: Creation complete after 1s [id=sgrule-1248809104]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["egress_nodes_443"]: Creation complete after 1s [id=sgrule-1564356326]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_self_coredns_tcp"]: Creating...
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_ntp_tcp"]: Creating...
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_cluster_kubelet"]: Creation complete after 2s [id=sgrule-185849198]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_https"]: Creating...
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["ingress_nodes_443"]: Creation complete after 2s [id=sgrule-713150079]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_self_coredns_tcp"]: Creating...
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_self_coredns_udp"]: Creation complete after 2s [id=sgrule-4063929015]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["egress_nodes_kubelet"]: Creation complete after 2s [id=sgrule-1134052351]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_cluster_443"]: Creation complete after 3s [id=sgrule-517676681]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_cluster_443"]: Creation complete after 4s [id=sgrule-4274022729]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_self_coredns_udp"]: Creation complete after 5s [id=sgrule-3950591054]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_self_coredns_tcp"]: Creation complete after 5s [id=sgrule-1696513576]
module.eks_blueprints.module.kms[0].aws_kms_key.this: Still creating... [10s elapsed]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_ntp_tcp"]: Creation complete after 6s [id=sgrule-888239517]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_https"]: Creation complete after 6s [id=sgrule-3945744515]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_self_coredns_tcp"]: Creation complete after 7s [id=sgrule-1449460056]
module.eks_blueprints.module.kms[0].aws_kms_key.this: Still creating... [20s elapsed]
module.eks_blueprints.module.kms[0].aws_kms_key.this: Creation complete after 24s [id=46e1d037-58f1-4013-b0c8-daead745c5e9]
module.eks_blueprints.module.kms[0].aws_kms_alias.this: Creating...
module.eks_blueprints.module.aws_eks.aws_eks_cluster.this[0]: Creating...
module.eks_blueprints.module.kms[0].aws_kms_alias.this: Creation complete after 0s [id=alias/eks-lab]
module.eks_blueprints.module.aws_eks.aws_eks_cluster.this[0]: Still creating... [10s elapsed]
module.eks_blueprints.module.aws_eks.aws_eks_cluster.this[0]: Still creating... [20s elapsed]
module.eks_blueprints.module.aws_eks.aws_eks_cluster.this[0]: Still creating... [9m51s elapsed]
module.eks_blueprints.module.aws_eks.aws_eks_cluster.this[0]: Still creating... [10m1s elapsed]
module.eks_blueprints.module.aws_eks.aws_eks_cluster.this[0]: Still creating... [10m11s elapsed]
module.eks_blueprints.module.aws_eks.aws_eks_cluster.this[0]: Creation complete after 10m12s [id=eks-lab]
module.eks_blueprints.module.aws_eks.data.tls_certificate.this[0]: Reading...
module.eks_blueprints.data.aws_eks_cluster.cluster[0]: Reading...
data.aws_eks_cluster_auth.this: Reading...
module.eks_blueprints.module.aws_eks.aws_ec2_tag.cluster_primary_security_group["GithubRepo"]: Creating...
data.aws_eks_cluster_auth.this: Read complete after 0s [id=eks-lab]
module.eks_blueprints.module.aws_eks.aws_ec2_tag.cluster_primary_security_group["Blueprint"]: Creating...
module.eks_blueprints.data.aws_eks_cluster.cluster[0]: Read complete after 0s [id=eks-lab]
module.eks_blueprints.data.http.eks_cluster_readiness[0]: Reading...
module.eks_blueprints.module.aws_eks.data.tls_certificate.this[0]: Read complete after 1s [id=8cb781b6037f4703f17f42d8de4a2c2aa78474ab]
module.eks_blueprints.module.aws_eks.aws_iam_openid_connect_provider.oidc_provider[0]: Creating...
module.eks_blueprints.data.http.eks_cluster_readiness[0]: Read complete after 1s [id=https://4595A6C8421EA3271502E6BFE65234E8.yl4.us-east-1.eks.amazonaws.com/healthz]
module.eks_blueprints.module.aws_eks_teams[0].data.aws_eks_cluster.eks_cluster: Reading...
module.eks_blueprints.kubernetes_config_map.aws_auth[0]: Creating...
module.eks_blueprints.module.aws_eks_teams[0].data.aws_eks_cluster.eks_cluster: Read complete after 0s [id=eks-lab]
module.eks_blueprints.module.aws_eks_teams[0].data.aws_iam_policy_document.platform_team_eks_access[0]: Reading...
module.eks_blueprints.module.aws_eks_teams[0].data.aws_iam_policy_document.platform_team_eks_access[0]: Read complete after 0s [id=2071923746]
module.eks_blueprints.module.aws_eks_teams[0].aws_iam_policy.platform_team_eks_access[0]: Creating...
module.eks_blueprints.module.aws_eks.aws_ec2_tag.cluster_primary_security_group["GithubRepo"]: Creation complete after 1s [id=sg-097787fc6ec7914b4,GithubRepo]
module.eks_blueprints.module.aws_eks.aws_ec2_tag.cluster_primary_security_group["Blueprint"]: Creation complete after 1s [id=sg-097787fc6ec7914b4,Blueprint]
module.eks_blueprints.kubernetes_config_map.aws_auth[0]: Creation complete after 1s [id=kube-system/aws-auth]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].data.aws_iam_policy_document.managed_ng_assume_role_policy: Reading...
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].data.aws_iam_policy_document.managed_ng_assume_role_policy: Read complete after 0s [id=3778018924]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_iam_role.managed_ng[0]: Creating...
module.eks_blueprints.module.aws_eks.aws_iam_openid_connect_provider.oidc_provider[0]: Creation complete after 1s [id=arn:aws:iam::261106957109:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/4595A6C8421EA3271502E6BFE65234E8]
module.eks_blueprints.module.aws_eks_teams[0].aws_iam_policy.platform_team_eks_access[0]: Creation complete after 1s [id=arn:aws:iam::261106957109:policy/eks-lab-PlatformTeamEKSAccess]
module.eks_blueprints.module.aws_eks_teams[0].aws_iam_role.platform_team["admin"]: Creating...
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_iam_role.managed_ng[0]: Creation complete after 0s [id=eks-lab-managed-ondemand]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_iam_role_policy_attachment.managed_ng["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]: Creating...
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_iam_role_policy_attachment.managed_ng["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"]: Creating...
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_iam_instance_profile.managed_ng[0]: Creating...
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_iam_role_policy_attachment.managed_ng["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]: Creating...
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_iam_role_policy_attachment.managed_ng["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]: Creating...
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_iam_role_policy_attachment.managed_ng["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"]: Creation complete after 1s [id=eks-lab-managed-ondemand-20230317015006719000000005]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_iam_role_policy_attachment.managed_ng["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]: Creation complete after 1s [id=eks-lab-managed-ondemand-20230317015006746000000006]
module.eks_blueprints.module.aws_eks_teams[0].aws_iam_role.platform_team["admin"]: Creation complete after 1s [id=eks-lab-admin-access]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_iam_role_policy_attachment.managed_ng["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]: Creation complete after 1s [id=eks-lab-managed-ondemand-20230317015006881700000007]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_iam_role_policy_attachment.managed_ng["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]: Creation complete after 1s [id=eks-lab-managed-ondemand-20230317015006930500000008]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_iam_instance_profile.managed_ng[0]: Creation complete after 1s [id=eks-lab-managed-ondemand]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Creating...
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [10s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [20s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [30s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [40s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [50s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [1m0s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [1m11s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [1m21s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [1m31s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [1m41s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [1m51s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [2m1s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [2m11s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Still creating... [2m21s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_MICRO"].aws_eks_node_group.managed_ng: Creation complete after 2m21s [id=eks-lab:managed-ondemand-20230317015007446200000009]
╷
│ Warning: Resource targeting is in effect
│
│ You are creating a plan with the -target option, which means that the result of this plan may not represent all of the changes requested by the current configuration.
│
│ The -target option is not for routine use, and is provided only for exceptional situations such as recovering from errors or mistakes, or when Terraform specifically suggests to use
│ it as part of an error message.
╵
╷
│ Warning: Applied changes may be incomplete
│
│ The plan was created with the -target option in effect, so some changes requested in the configuration may have been ignored and the output values may not be fully updated. Run the
│ following command to verify that no other changes are pending:
│     terraform plan
│
│ Note that the -target option is not suitable for routine use, and is provided only for exceptional situations such as recovering from errors or mistakes, or when Terraform
│ specifically suggests to use it as part of an error message.
╵

Apply complete! Resources: 34 added, 0 changed, 0 destroyed.

Outputs:

configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-0d44fe109e4cd1482"
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab$

Apply complete! Resources: 34 added, 0 changed, 0 destroyed.

Outputs:

configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-0d44fe109e4cd1482"
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab$




aplicando novamente

ge, 0 to destroy.

Changes to Outputs:
  + configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
  + vpc_id            = "vpc-0d44fe109e4cd1482"
module.eks_blueprints.module.aws_eks.aws_ec2_tag.cluster_primary_security_group["Blueprint"]: Creating...
module.eks_blueprints.module.aws_eks.aws_ec2_tag.cluster_primary_security_group["GithubRepo"]: Creating...
module.eks_blueprints.module.kms[0].aws_kms_alias.this: Creating...
module.vpc.aws_default_security_group.this[0]: Creating...
module.vpc.aws_default_network_acl.this[0]: Creating...
module.eks_blueprints.module.aws_eks.aws_iam_openid_connect_provider.oidc_provider[0]: Creating...
module.vpc.aws_default_route_table.default[0]: Creating...
module.vpc.aws_internet_gateway.this[0]: Creating...
module.eks_blueprints.module.aws_eks_teams[0].aws_iam_policy.platform_team_eks_access[0]: Creating...
module.vpc.aws_route_table.public[0]: Creating...
module.eks_blueprints.module.kms[0].aws_kms_alias.this: Creation complete after 0s [id=alias/eks-lab]
module.vpc.aws_subnet.public[2]: Creating...
module.eks_blueprints.module.aws_eks.aws_ec2_tag.cluster_primary_security_group["GithubRepo"]: Creation complete after 1s [id=sg-097787fc6ec7914b4,GithubRepo]
module.vpc.aws_subnet.public[0]: Creating...
module.eks_blueprints.module.aws_eks.aws_ec2_tag.cluster_primary_security_group["Blueprint"]: Creation complete after 1s [id=sg-097787fc6ec7914b4,Blueprint]
module.vpc.aws_subnet.public[1]: Creating...
module.eks_blueprints.module.aws_eks.aws_iam_openid_connect_provider.oidc_provider[0]: Creation complete after 1s [id=arn:aws:iam::261106957109:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/4595A6C8421EA3271502E6BFE65234E8]
module.vpc.aws_route_table.private[0]: Creating...
module.vpc.aws_default_route_table.default[0]: Creation complete after 1s [id=rtb-04e1b49736c0981f0]
module.vpc.aws_eip.nat[0]: Creating...
module.eks_blueprints.module.aws_eks_teams[0].aws_iam_policy.platform_team_eks_access[0]: Creation complete after 1s [id=arn:aws:iam::261106957109:policy/eks-lab-PlatformTeamEKSAccess]
module.eks_blueprints.module.aws_eks_teams[0].aws_iam_role.platform_team["admin"]: Creating...
module.vpc.aws_internet_gateway.this[0]: Creation complete after 1s [id=igw-0366ba5b63c5865ac]
module.vpc.aws_route_table.public[0]: Creation complete after 1s [id=rtb-0152f2771d93cb234]
module.vpc.aws_route.public_internet_gateway[0]: Creating...
module.vpc.aws_default_security_group.this[0]: Creation complete after 2s [id=sg-06993bc5012a47eb9]
module.vpc.aws_route_table.private[0]: Creation complete after 1s [id=rtb-032dc66d35ad28942]
module.vpc.aws_route_table_association.private[1]: Creating...
module.vpc.aws_route_table_association.private[0]: Creating...
module.vpc.aws_route_table_association.private[2]: Creating...
module.vpc.aws_eip.nat[0]: Creation complete after 1s [id=eipalloc-03ac7d8bc157b88cd]
module.eks_blueprints.module.aws_eks_teams[0].aws_iam_role.platform_team["admin"]: Creation complete after 1s [id=eks-lab-admin-access]
kubectl_manifest.rbac_teste: Creating...
module.vpc.aws_route.public_internet_gateway[0]: Creation complete after 1s [id=r-rtb-0152f2771d93cb2341080289494]
module.vpc.aws_route_table_association.private[0]: Creation complete after 1s [id=rtbassoc-02fab5956d1dd118c]
module.vpc.aws_route_table_association.private[1]: Creation complete after 1s [id=rtbassoc-0eaf3599daffd030c]
module.vpc.aws_route_table_association.private[2]: Creation complete after 1s [id=rtbassoc-0af4e7d28d8c444e3]
module.vpc.aws_default_network_acl.this[0]: Creation complete after 3s [id=acl-0d45a73346227e49e]
kubectl_manifest.rbac_teste: Creation complete after 1s [id=/apis/rbac.authorization.k8s.io/v1/clusterroles/eks-console-dashboard-full-access-clusterrole]
module.vpc.aws_subnet.public[2]: Still creating... [10s elapsed]
module.vpc.aws_subnet.public[0]: Still creating... [10s elapsed]
module.vpc.aws_subnet.public[1]: Still creating... [10s elapsed]
module.vpc.aws_subnet.public[2]: Creation complete after 12s [id=subnet-06ae07e1c9f5e0201]
module.vpc.aws_subnet.public[0]: Creation complete after 11s [id=subnet-019349fb03917fbae]
module.vpc.aws_subnet.public[1]: Creation complete after 11s [id=subnet-099895018ab13eaf7]
module.vpc.aws_route_table_association.public[1]: Creating...
module.vpc.aws_route_table_association.public[2]: Creating...
module.vpc.aws_nat_gateway.this[0]: Creating...
module.vpc.aws_route_table_association.public[0]: Creating...
module.vpc.aws_route_table_association.public[1]: Creation complete after 1s [id=rtbassoc-063cad50a44030d00]
module.vpc.aws_route_table_association.public[0]: Creation complete after 1s [id=rtbassoc-06f577e03c01889bf]
module.vpc.aws_route_table_association.public[2]: Creation complete after 1s [id=rtbassoc-0524751b8cd1968b4]
module.vpc.aws_nat_gateway.this[0]: Still creating... [10s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [20s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [30s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [40s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [50s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m0s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m10s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m20s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m30s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m40s elapsed]
module.vpc.aws_nat_gateway.this[0]: Creation complete after 1m47s [id=nat-0b262572cddf103b3]
module.vpc.aws_route.private_nat_gateway[0]: Creating...
module.vpc.aws_route.private_nat_gateway[0]: Creation complete after 2s [id=r-rtb-032dc66d35ad289421080289494]

Apply complete! Resources: 26 added, 0 changed, 0 destroyed.

Outputs:

configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-0d44fe109e4cd1482"
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/07-eks-lab$

~~~~







fernando@debian10x64:~$ kubectl get nodes
NAME                          STATUS   ROLES    AGE     VERSION
ip-10-0-10-68.ec2.internal    Ready    <none>   5m16s   v1.23.16-eks-48e63af
ip-10-0-11-248.ec2.internal   Ready    <none>   5m16s   v1.23.16-eks-48e63af
ip-10-0-12-212.ec2.internal   Ready    <none>   5m      v1.23.16-eks-48e63af
fernando@debian10x64:~$

fernando@debian10x64:~$ kubectl get clusterroles -A | grep console
eks-console-dashboard-full-access-clusterrole                          2023-03-17T02:00:09Z
fernando@debian10x64:~$




fernando@debian10x64:~$ kubectl auth can-i "*" "*"

yes
fernando@debian10x64:~$



# penndente
tentar
https://antonputra.com/kubernetes/add-iam-user-and-iam-role-to-eks/#add-iam-role-to-eks-cluster
ler
https://echorand.me/posts/user-management-aws-eks-cluster/
tshoot, assumerole


terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve






# Dia 18/03/2023

terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks_blueprints -auto-approve
terraform apply -auto-approve






terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve



https://echorand.me/posts/user-management-aws-eks-cluster/


# penndente
tentar
https://antonputra.com/kubernetes/add-iam-user-and-iam-role-to-eks/#add-iam-role-to-eks-cluster
ler, tentar AssumeRole, abaixo:
https://echorand.me/posts/user-management-aws-eks-cluster/
tshoot, assumerole









# Dia 21/03/2023


terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks_blueprints -auto-approve
terraform apply -auto-approve