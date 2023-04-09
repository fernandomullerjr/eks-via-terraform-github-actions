

# 09-eks-lab

- Projeto usando eks-blueprint
https://catalog.workshops.aws/eks-blueprints-terraform/en-US/030-provision-eks-cluster/1-create-a-terraform-project



# RESUMO
terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks_blueprints -auto-approve
terraform apply -auto-approve

terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve



# SOLUÇÃO
- Para usuários comuns, adicionar o arn do usuário normal.
- Para usuário root, adicionar arn "arn:aws:iam::261106957109:root" ao invés do arn do usuário com nome do usuário.

## Obs
- Seguir o README no Apply e no Destroy.
- Cuidar extensão do nome(no locals.tf), para não formar um nome muito longo ao recurso.





# Dia 01/04/2023

- Subindo o Cluster

terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks_blueprints -auto-approve
terraform apply -auto-approve



configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-0ed9e220a20ab86ad"



fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ kubectl get nodes
NAME                          STATUS   ROLES    AGE     VERSION
ip-10-0-10-13.ec2.internal    Ready    <none>   6m15s   v1.23.17-eks-a59e1f0
ip-10-0-11-11.ec2.internal    Ready    <none>   6m13s   v1.23.17-eks-a59e1f0
ip-10-0-12-229.ec2.internal   Ready    <none>   6m12s   v1.23.17-eks-a59e1f0
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ date
Sat 01 Apr 2023 07:51:01 PM -03
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$










- Deploy Prometheus pro EKS via Helm

https://docs.aws.amazon.com/eks/latest/userguide/prometheus.html


fernando@debian10x64:~$ history | tail -n 23
  523  aws eks --region us-east-1 update-kubeconfig --name eks-lab
  524  ls -lhasp ~/.aws/credentials
  525  cat ~/.aws/credentials
  526  aws eks --region us-east-1 update-kubeconfig --name eks-lab
  527  cat ~/.aws/credentials
  528  rm ~/.aws/credentials
  529  aws configure
  530  rm ~/.aws/credentials
  531  aws configure
  532  cat ~/.aws/credentials
  533  aws s3 ls
  534  aws eks --region us-east-1 update-kubeconfig --name eks-lab
  535  helm upgrade -i prometheus prometheus-community/prometheus     --namespace prometheus     --set alertmanager.persistentVolume.storageClass="gp2",server.persistentVolume.storageClass="gp2"
  536  kubectl get pods -n prometheus
  537  kubectl --namespace=prometheus port-forward deploy/prometheus-server 9090
  538  kubectl get pods -n prometheus
  539  kubectl logs prometheus-server-5fc6895768-q4btl  -n prometheus
  540  kubectl describe pod  prometheus-server-5fc6895768-q4btl  -n prometheus
  541  kubectl get events
  542  date
  543  kubectl get events -A
  544  history | tail
  545  history | tail -n 23
fernando@debian10x64:~$






- Pods em pending


fernando@debian10x64:~$ kubectl get pods -n prometheus
NAME                                                 READY   STATUS    RESTARTS   AGE
prometheus-alertmanager-0                            0/1     Pending   0          9m2s
prometheus-kube-state-metrics-5d888875ff-r662x       0/1     Pending   0          9m2s
prometheus-prometheus-node-exporter-2xnjf            1/1     Running   0          9m3s
prometheus-prometheus-node-exporter-j5p74            0/1     Pending   0          9m3s
prometheus-prometheus-node-exporter-wzmfn            1/1     Running   0          9m3s
prometheus-prometheus-pushgateway-6445c657fc-fdsdt   1/1     Running   0          9m2s
prometheus-server-5fc6895768-q4btl                   0/2     Pending   0          9m2s
fernando@debian10x64:~$





fernando@debian10x64:~$
fernando@debian10x64:~$ kubectl get events -A | tail -n 55

kube-system   57m         Normal    LeaderElection            lease/kube-scheduler                                      ip-172-16-181-39.ec2.internal_5f483080-b58b-4344-b56c-3f905c8341d6 became leader
prometheus    42s         Warning   FailedScheduling          pod/prometheus-alertmanager-0                             0/3 nodes are available: 3 Too many pods.
prometheus    9m21s       Normal    SuccessfulCreate          statefulset/prometheus-alertmanager                       create Claim storage-prometheus-alertmanager-0 Pod prometheus-alertmanager-0 in StatefulSet prometheus-alertmanager success
prometheus    9m21s       Normal    SuccessfulCreate          statefulset/prometheus-alertmanager                       create Pod prometheus-alertmanager-0 in StatefulSet prometheus-alertmanager successful
prometheus    42s         Warning   FailedScheduling          pod/prometheus-kube-state-metrics-5d888875ff-r662x        0/3 nodes are available: 3 Too many pods.





- Subindo 2 nodes
Node group configuration update in progress
managed-ondemand-20230401224215077500000009 configuration is now being updated. This process may take several minutes.

desired
DE:
3
PARA:
5

- Ajustado máximo para 7



~~~~bash
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ kubectl get nodes
NAME                          STATUS     ROLES    AGE   VERSION
ip-10-0-10-13.ec2.internal    Ready      <none>   58m   v1.23.17-eks-a59e1f0
ip-10-0-11-11.ec2.internal    Ready      <none>   58m   v1.23.17-eks-a59e1f0
ip-10-0-11-48.ec2.internal    NotReady   <none>   18s   v1.23.17-eks-a59e1f0
ip-10-0-12-158.ec2.internal   NotReady   <none>   18s   v1.23.17-eks-a59e1f0
ip-10-0-12-229.ec2.internal   Ready      <none>   58m   v1.23.17-eks-a59e1f0
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$


fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ kubectl get nodes
NAME                          STATUS   ROLES    AGE     VERSION
ip-10-0-10-13.ec2.internal    Ready    <none>   60m     v1.23.17-eks-a59e1f0
ip-10-0-11-11.ec2.internal    Ready    <none>   60m     v1.23.17-eks-a59e1f0
ip-10-0-11-48.ec2.internal    Ready    <none>   2m44s   v1.23.17-eks-a59e1f0
ip-10-0-12-158.ec2.internal   Ready    <none>   2m44s   v1.23.17-eks-a59e1f0
ip-10-0-12-229.ec2.internal   Ready    <none>   60m     v1.23.17-eks-a59e1f0
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$
~~~~




- Mesmo com mais Nodes, ocorrem erros para Schedular os Pods:

~~~~bash
default       60m         Normal    Starting                  node/ip-10-0-12-229.ec2.internal
prometheus    0s          Warning   FailedScheduling          pod/prometheus-server-5fc6895768-q4btl                    0/5 nodes are available: 1 node(s) didn't find available persistent volumes to bind, 4 Too many pods.

default       61m         Normal    Starting                  node/ip-10-0-10-13.ec2.internal
prometheus    0s          Normal    ExternalProvisioning      persistentvolumeclaim/storage-prometheus-alertmanager-0   waiting for a volume to be created, either by external provisioner "ebs.csi.aws.com" or manually created by system administrator
prometheus    0s          Normal    ExternalProvisioning      persistentvolumeclaim/prometheus-server                   waiting for a volume to be created, either by external provisioner "ebs.csi.aws.com" or manually created by system administrator
prometheus    0s          Warning   FailedScheduling          pod/prometheus-server-5fc6895768-q4btl                    0/5 nodes are available: 1 node(s) didn't find available persistent volumes to bind, 4 Too many pods.
prometheus    0s          Warning   FailedScheduling          pod/prometheus-prometheus-node-exporter-j5p74             0/5 nodes are available: 1 Too many pods, 4 node(s) didn't match Pod's node affinity/selector.
Events (2)
Type
	
Reason
	
Event time
	
From
	
Message
Warning	FailedScheduling	7 minutes ago	default-scheduler	0/3 nodes are available: 1 Too many pods, 2 node(s) didn't match Pod's node affinity/selector.
Warning	FailedScheduling	a minute ago	default-scheduler	0/5 nodes are available: 1 Too many pods, 4 node(s) didn't match Pod's node affinity/selector.
~~~~










- Affinity

~~~~YAML
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchFields:
          - key: metadata.name
            operator: In
            values:
            - ip-10-0-11-11.ec2.internal
  automountServiceAccountToken: false
~~~~



~~~~bash
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ kubectl get pods -n prometheus
NAME                                                 READY   STATUS    RESTARTS   AGE
prometheus-alertmanager-0                            0/1     Pending   0          25m
prometheus-kube-state-metrics-5d888875ff-r662x       1/1     Running   0          25m
prometheus-prometheus-node-exporter-2xnjf            1/1     Running   0          25m
prometheus-prometheus-node-exporter-j5p74            0/1     Pending   0          25m
prometheus-prometheus-node-exporter-nwbc6            1/1     Running   0          9m17s
prometheus-prometheus-node-exporter-nzhj7            1/1     Running   0          9m18s
prometheus-prometheus-node-exporter-wzmfn            1/1     Running   0          25m
prometheus-prometheus-pushgateway-6445c657fc-fdsdt   1/1     Running   0          25m
prometheus-server-5fc6895768-q4btl                   0/2     Pending   0          25m
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ kubectl delete pod prometheus-prometheus-node-exporter-j5p74 -n prometheus -o yaml
error: unexpected -o output mode: yaml. We only support '-o name'
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ kubectl delete pod prometheus-prometheus-node-exporter-j5p74 -n prometheus
pod "prometheus-prometheus-node-exporter-j5p74" deleted
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ kubectl get pods -n prometheus
NAME                                                 READY   STATUS    RESTARTS   AGE
prometheus-alertmanager-0                            0/1     Pending   0          27m
prometheus-kube-state-metrics-5d888875ff-r662x       1/1     Running   0          27m
prometheus-prometheus-node-exporter-2xnjf            1/1     Running   0          27m
prometheus-prometheus-node-exporter-nwbc6            1/1     Running   0          11m
prometheus-prometheus-node-exporter-nzhj7            1/1     Running   0          11m
prometheus-prometheus-node-exporter-rvplh            0/1     Pending   0          70s
prometheus-prometheus-node-exporter-wzmfn            1/1     Running   0          27m
prometheus-prometheus-pushgateway-6445c657fc-fdsdt   1/1     Running   0          27m
prometheus-server-5fc6895768-q4btl                   0/2     Pending   0          27m
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$
~~~~



- Provável quantidade elevada de Pods no t3a.micro, apenas DaemonSet do Node-exporter nao sobe todos num Node apenas.

~~~~bash
/5 nodes are available: 1 node(s) didn't find available persistent volumes to bind, 4 Too many pods.
prometheus    0s          Warning   FailedScheduling          pod/prometheus-prometheus-node-exporter-rvplh             0/5 nodes are available: 1 Too many pods, 4 node(s) didn't match Pod's node affinity/selector.
prometheus    0s          Normal    ExternalProvisioning      persistentvolumeclaim/prometheus-server                   waiting for a volume to be created, either by external provisioner "ebs.csi.aws.com" or manually created by system administrator
prometheus    0s          Normal    ExternalProvisioning      persistentvolumeclaim/storage-prometheus-alertmanager-0   waiting for a volume to be created, either by external provisioner "ebs.csi.aws.com" or manually created by system administrator
prometheus    0s          Warning   FailedScheduling          pod/prometheus-server-5fc6895768-q4btl                    0/5 nodes are available: 1 node(s) didn't find available persistent volumes to bind, 4 Too many pods.
prometheus    0s          Warning   FailedScheduling          pod/prometheus-prometheus-node-exporter-rvplh             0/5 nodes are available: 1 Too many pods, 4 node(s) didn't match Pod's node affinity/selector.
prometheus    0s          Warning   FailedScheduling          pod/prometheus-server-5fc6895768-q4btl                    0/5 nodes are available: 1 node(s) didn't find available persistent volumes to bind, 4 Too many pods.
prometheus    0s          Warning   FailedScheduling          pod/prometheus-prometheus-node-exporter-rvplh             0/5 nodes are available: 1 Too many pods, 4 node(s) didn't match Pod's node affinity/selector.
prometheus    0s          Warning   FailedScheduling          pod/prometheus-server-5fc6895768-q4btl                    0/5 nodes are available: 1 node(s) didn't find available persistent volumes to bind, 4 Too many pods.
prometheus    0s          Warning   FailedScheduling          pod/prometheus-prometheus-node-exporter-rvplh             0/5 nodes are available: 1 Too many pods, 4 node(s) didn't match Pod's node affinity/selector.
~~~~




- Subindo para 7
Node group configuration update in progress
managed-ondemand-20230401224215077500000009 configuration is now being updated. This process may take several minutes.


- Efetuando destroy

terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve

exceptional situations such as recovering from errors or mistakes, or when Terraform
│ specifically suggests to use it as part of an error message.
╵

Destroy complete! Resources: 23 destroyed.
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ terraform destroy -auto-approve
]
Changes to Outputs:
  - configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab" -> null
  - vpc_id            = "vpc-0ed9e220a20ab86ad" -> null

You can apply this plan to save these new output values to the Terraform state, without changing any real infrastructure.

Destroy complete! Resources: 0 destroyed.
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ ]












# PENDENTE

- Tratar erros, provavel familia t3a.micro não suporta muitos Pods, ENI, etc. Então o "prometheus-server" e o "Node-exporter" apresentam erro no schedular.
- Subir Prometheus e Grafana via Helm
https://docs.aws.amazon.com/eks/latest/userguide/prometheus.html
https://archive.eksworkshop.com/intermediate/240_monitoring/
- Testar métricas, endpoints








----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

# Dia 08/04/2023

terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks_blueprints -auto-approve
terraform apply -auto-approve


- Verificando a capacidade de Pods por familia de EC2:

https://github.com/awslabs/amazon-eks-ami/blob/master/files/eni-max-pods.txt

t3a.micro 4
t3a.small 8
t3a.medium 17

- Valores por hora:

t3a.nano	0,0047 USD	2	0,5 GiB	Somente EBS	Até 5 gigabits
t3a.micro	0,0094 USD	2	1 GiB	Somente EBS	Até 5 gigabits
t3a.small	0,0188 USD	2	2 GiB	Somente EBS	Até 5 gigabits
t3a.medium	0,0376 USD	2	4 GiB	Somente EBS	Até 5 gigabits
t3a.large	0,0752 USD	2	8 GiB	Somente EBS	Até 5 gigabits



- Ajustando o manifesto, para utilizar a familia [t3a.medium] ao invés da micro:

/home/fernando/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint/main.tf

~~~~h
  # EKS MANAGED NODE GROUPS
  managed_node_groups = {
    T3A_NODE = {
      node_group_name = local.node_group_name
      instance_types  = ["t3a.medium"]
      subnet_ids      = module.vpc.private_subnets
    }
  }
~~~~



- Aplicando eks:

terraform apply -target=module.eks_blueprints -auto-approve



terraform apply -auto-approve




configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-0a522b806f302ae0a"

21:32h








https://catalog.workshops.aws/eks-blueprints-terraform/en-US/050-observability/2-metrics-kube-prometheus-stack



### Metrics

Metrics with Kube Prometheus Stack

Another add-on that is available on EKS Blueprints for Terraform is Kube Prometheus Stack. This particular add-on when enabled installs Prometheus instance, Prometheus operator, kube-state-metrics, node-exporter, alertmanager as well as Grafana instance with preconfigured dashboards. This stack is meant for cluster monitoring, so it is pre-configured to collect metrics from all Kubernetes components. In addition to that it delivers a default set of dashboards and alerting rules. More on kube-prometheus-stack 

.

Add following configuration under kubernetes_addons section in your main.tf file:

~~~~h
module "kubernetes_addons" {
source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.22.0/modules/kubernetes-addons"
... ommitted content for brevity ...

  enable_aws_load_balancer_controller  = true
  enable_amazon_eks_aws_ebs_csi_driver = true
  enable_aws_for_fluentbit             = true
  enable_metrics_server                = true
  enable_argo_rollouts                 = true 
  enable_kube_prometheus_stack         = true # <-- Add this line

... ommitted content for brevity ...
}
~~~~


And, apply changes:

# Always a good practice to use a dry-run command

terraform plan

# Apply changes to provision the Platform Team

terraform apply -auto-approve









- Editado:

~~~~h
# Prometheus Stack, usando addons

module "kubernetes_addons" {
source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.21.0/modules/kubernetes-addons"
  enable_metrics_server                = true
  enable_kube_prometheus_stack         = true # <-- Add this line
}
~~~~



And, apply changes:

# Always a good practice to use a dry-run command

terraform plan

# Apply changes to provision the Platform Team

terraform apply -auto-approve





fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ terraform plan
╷
│ Error: Module not installed
│
│   on main.tf line 94:
│   94: module "kubernetes_addons" {
│
│ This module is not yet installed. Run "terraform init" to install all modules required by this configuration.
╵
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$




- Erros durante o terraform init
- Não é possível baixar o kubernetes_addons, pede autenticação no Github do ondat:

Downloading registry.terraform.io/ondat/ondat-addon/eksblueprints 0.1.2 for kubernetes_addons.ondat...
Username for 'https://github.com':



- Removendo do main.tf

~~~~h
# Prometheus Stack, usando addons

module "kubernetes_addons" {
source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.22.0/modules/kubernetes-addons"
  enable_metrics_server                = true
  enable_kube_prometheus_stack         = true # <-- Add this line
}
~~~~



- Usando o Addon do site abaixo não funcionou:
https://catalog.workshops.aws/eks-blueprints-terraform/en-US/050-observability/2-metrics-kube-prometheus-stack#metrics-with-kube-prometheus-stack
<https://catalog.workshops.aws/eks-blueprints-terraform/en-US/050-observability/2-metrics-kube-prometheus-stack#metrics-with-kube-prometheus-stack>





- Efetuando o Deploy via Helm, usando o site abaixo:
https://docs.aws.amazon.com/eks/latest/userguide/prometheus.html
<https://docs.aws.amazon.com/eks/latest/userguide/prometheus.html>


kubectl create namespace prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade -i prometheus prometheus-community/prometheus \
    --namespace prometheus \
    --set alertmanager.persistentVolume.storageClass="gp2",server.persistentVolume.storageClass="gp2"


~~~~bash

fernando@debian10x64:~$ helm ls -A
NAME    NAMESPACE       REVISION        UPDATED STATUS  CHART   APP VERSION
fernando@debian10x64:~$ kubectl create namespace prometheus
namespace/prometheus created
fernando@debian10x64:~$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
"prometheus-community" already exists with the same configuration, skipping
fernando@debian10x64:~$ helm upgrade -i prometheus prometheus-community/prometheus \
>     --namespace prometheus \
>     --set alertmanager.persistentVolume.storageClass="gp2",server.persistentVolume.storageClass="gp2"
Release "prometheus" does not exist. Installing it now.
NAME: prometheus
LAST DEPLOYED: Sat Apr  8 22:07:24 2023
NAMESPACE: prometheus
STATUS: deployed
REVISION: 1
NOTES:
The Prometheus server can be accessed via port 80 on the following DNS name from within your cluster:
prometheus-server.prometheus.svc.cluster.local


Get the Prometheus server URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace prometheus -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace prometheus port-forward $POD_NAME 9090


The Prometheus alertmanager can be accessed via port  on the following DNS name from within your cluster:
prometheus-%!s(<nil>).prometheus.svc.cluster.local


Get the Alertmanager URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace prometheus -l "app=prometheus,component=" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace prometheus port-forward $POD_NAME 9093
#################################################################################
######   WARNING: Pod Security Policy has been disabled by default since    #####
######            it deprecated after k8s 1.25+. use                        #####
######            (index .Values "prometheus-node-exporter" "rbac"          #####
###### .          "pspEnabled") with (index .Values                         #####
######            "prometheus-node-exporter" "rbac" "pspAnnotations")       #####
######            in case you still need it.                                #####
#################################################################################


The Prometheus PushGateway can be accessed via port 9091 on the following DNS name from within your cluster:
prometheus-prometheus-pushgateway.prometheus.svc.cluster.local


Get the PushGateway URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace prometheus -l "app=prometheus-pushgateway,component=pushgateway" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace prometheus port-forward $POD_NAME 9091

For more information on running Prometheus, visit:
https://prometheus.io/
fernando@debian10x64:~$

fernando@debian10x64:~$ helm ls -A
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
prometheus      prometheus      1               2023-04-08 22:07:24.961575886 -0300 -03 deployed        prometheus-20.0.2       v2.43.0
fernando@debian10x64:~$ date
Sat 08 Apr 2023 10:07:57 PM -03
fernando@debian10x64:~$

~~~~