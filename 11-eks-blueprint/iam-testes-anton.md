




https://antonputra.com/kubernetes/add-iam-user-and-iam-role-to-eks/#add-iam-role-to-eks-cluster



fernando@debian10x64:~$ aws iam get-role --role-name eks-admin
{
    "Role": {
        "Path": "/",
        "RoleName": "eks-admin",
        "RoleId": "AROATZSZP7M2VKWYCREU7",
        "Arn": "arn:aws:iam::261106957109:role/eks-admin",
        "CreateDate": "2023-03-18T04:01:31+00:00",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": "arn:aws:iam::261106957109:root"
                    },
                    "Action": "sts:AssumeRole",
                    "Condition": {}
                }
            ]
        },
        "Description": "eks-admin",
        "MaxSessionDuration": 3600,
        "RoleLastUsed": {}
    }
}
fernando@debian10x64:~$










For any user that wants to use eks-admin IAM role, we need to create an additional AmazonEKSAssumeEKSAdminPolicy policy, that allows to assume the role.


AmazonEKSAssumeEKSAdminPolicy

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": "arn:aws:iam::261106957109:role/eks-admin"
        }
    ]
}





To test it, we need another IAM user. Let's create manager user and allow it to use eks-admin IAM role. In this case, just attach AmazonEKSAssumeEKSAdminPolicy directly to the user.





The same thing for this user, we need to create a manager aws profile.

aws configure --profile fernandomullerjr8596










You can check if the manager user can assume the eks-admin role by running the following command. If we get credentials back, it means we can use it.

aws sts assume-role \
  --role-arn arn:aws:iam::424432388155:role/eks-admin \
  --role-session-name manager-session \
  --profile manager




aws sts assume-role \
  --role-arn arn:aws:iam::261106957109:role/eks-admin \
  --role-session-name manager-session \
  --profile fernandomullerjr8596


ernando@debian10x64:~$
fernando@debian10x64:~$ aws sts assume-role \
>   --role-arn arn:aws:iam::261106957109:role/eks-admin \
>   --role-session-name manager-session \
>   --profile fernandomullerjr8596
{
    "Credentials": {
        "AccessKeyId": "ASIATZSZP7M2T4A6DOMW",
        "SecretAccessKey": "qufUXyK5/xpZcHzpXvacHLnd+Z8tjopwaP5WK0YO",
        "SessionToken": "FwoGZXIvYXdzEIb//////////wEaDL99A068GY7f7HPzuiKzAbFYMKJmc4+M6fRhu9ay7HRlja+HOfysNzmHFDsTklHRBZDfX3m7lQXYdHn35UnRYB/gjP89Zc10nw/MWOyvvvsLv1a8hY9Va68dYzXm7owdGiQsBjE7FZ9n+M0RLqhl4lMI9pTCuZ0abX5XmGjGqWtam+YaEOR6ZW87wMjMKyKIbLIKPLTsBpV+H7pjrsDN/E8bL9yD6YDc3Q0E3TsOW/gEePr3MoQPALNGSJAX1t9UJXopKOXx1KAGMi2A5oiK6j8iQr+wRcd0c4JSvZpt74Wvx4FZL+f3XH8px+j1a3L+B1MqEw6nF3U=",
        "Expiration": "2023-03-18T05:07:01+00:00"
    },
    "AssumedRoleUser": {
        "AssumedRoleId": "AROATZSZP7M2VKWYCREU7:manager-session",
        "Arn": "arn:aws:sts::261106957109:assumed-role/eks-admin/manager-session"
    }
}
fernando@debian10x64:~$






Now, we need to switch back to the user that created the EKS cluster. When you omit the profile, aws will use the default one.

aws eks --region us-east-1 update-kubeconfig --name demo










It's a very similar process to add an IAM role. You also need to update the aws-auth configmap. In this case, we will use Kubernetes RBAC group system:masters that ships with the cluster.

kubectl edit -n kube-system configmap/aws-auth

...
  mapRoles: |
    - rolearn: arn:aws:iam::424432388155:role/eks-admin
      username: eks-admin
      groups:
      - system:masters
...























fernando@debian10x64:~$
fernando@debian10x64:~$ aws eks --region us-east-1 update-kubeconfig --name eks-lab
Updated context arn:aws:eks:us-east-1:261106957109:cluster/eks-lab in /home/fernando/.kube/config
fernando@debian10x64:~$ kubectl get configmap -A
NAMESPACE         NAME                                 DATA   AGE
default           kube-root-ca.crt                     1      6m31s
kube-node-lease   kube-root-ca.crt                     1      6m32s
kube-public       kube-root-ca.crt                     1      6m32s
kube-system       aws-auth                             3      2m40s
kube-system       coredns                              1      6m33s
kube-system       cp-vpc-resource-controller           0      6m26s
kube-system       eks-certificates-controller          0      6m32s
kube-system       extension-apiserver-authentication   6      6m43s
kube-system       kube-proxy                           1      6m33s
kube-system       kube-proxy-config                    1      6m33s
kube-system       kube-root-ca.crt                     1      6m32s
fernando@debian10x64:~$ kubectl describe aws-auth -n kube-system
error: the server doesn't have a resource type "aws-auth"
fernando@debian10x64:~$ kubectl describe configmap aws-auth -n kube-system
Name:         aws-auth
Namespace:    kube-system
Labels:       app.kubernetes.io/created-by=terraform-aws-eks-blueprints
              app.kubernetes.io/managed-by=terraform-aws-eks-blueprints
Annotations:  <none>

Data
====
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
- "groups":
  - "system:masters"
  - "eks-console-dashboard-full-access-group"
  "userarn": "arn:aws:iam::261106957109:user/fernandomullerjr8596"
  "username": "fernandomullerjr8596"

mapAccounts:
----
[]


BinaryData
====

Events:  <none>
fernando@debian10x64:~$ kubectl config view --minify
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://0A688BCCC873759ECC5D169041F88083.gr7.us-east-1.eks.amazonaws.com
  name: arn:aws:eks:us-east-1:261106957109:cluster/eks-lab
contexts:
- context:
    cluster: arn:aws:eks:us-east-1:261106957109:cluster/eks-lab
    user: arn:aws:eks:us-east-1:261106957109:cluster/eks-lab
  name: arn:aws:eks:us-east-1:261106957109:cluster/eks-lab
current-context: arn:aws:eks:us-east-1:261106957109:cluster/eks-lab
kind: Config
preferences: {}
users:
- name: arn:aws:eks:us-east-1:261106957109:cluster/eks-lab
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      args:
      - --region
      - us-east-1
      - eks
      - get-token
      - --cluster-name
      - eks-lab
      command: aws
      env: null
      interactiveMode: IfAvailable
      provideClusterInfo: false
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$ kubectl auth can-i "*" "*"
yes
fernando@debian10x64:~$
