




----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

# ERRO

- Erro na Console:
Your current user or role does not have access to Kubernetes objects on this EKS cluster






----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

# SOLUÇÃO

# RESUMO

- Criando policy "my-console-viewer-policy"
- Criando a Role "my-console-viewer-role"
- Atrelar a policy "my-console-viewer-policy" na  Role "my-console-viewer-role".
- Aplicar no Cluster a estrutura RBAC.
- Editar trust policy da role, permitindo usuário do IAM.
- Editar ConfigMap "configmap/aws-auth", colocando os mapeamentos para a Role e para o usuário do IAM.



# Site-1:

<https://docs.aws.amazon.com/eks/latest/userguide/security_iam_troubleshoot.html#security-iam-troubleshoot-cannot-view-nodes-or-workloads>

Can't see Nodes on the Compute tab or anything on the Resources tab and you receive an error in the AWS Management Console

You may see a console error message that says Your current user or role does not have access to Kubernetes objects on this EKS cluster. Make sure that the IAM principal user that you're using the AWS Management Console with has the necessary permissions. For more information, see Required permissions.





# Site-2:

<https://docs.aws.amazon.com/eks/latest/userguide/view-kubernetes-resources.html#view-kubernetes-resources-permissions>


Required permissions

To view the Resources tab and Nodes section on the Compute tab in the AWS Management Console, the IAM principal that you're using must have specific minimum IAM and Kubernetes permissions. Complete the following steps to assign the required permissions to your IAM principals.

    Make sure that the eks:AccessKubernetesApi, and other necessary IAM permissions to view Kubernetes resources, are assigned to the IAM principal that you're using. For more information about how to edit permissions for an IAM principal, see Controlling access for principals in the IAM User Guide. For more information about how to edit permissions for a role, see Modifying a role permissions policy (console) in the IAM User Guide.

    The following example policy includes the necessary permissions for a principal to view Kubernetes resources for all clusters in your account. Replace 111122223333 with your AWS account ID. 


- EXEMPLO:

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
