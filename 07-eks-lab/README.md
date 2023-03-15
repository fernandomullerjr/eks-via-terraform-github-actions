

# 07-eks-lab

- Projeto usando eks-blueprint
https://catalog.workshops.aws/eks-blueprints-terraform/en-US/030-provision-eks-cluster/1-create-a-terraform-project









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












