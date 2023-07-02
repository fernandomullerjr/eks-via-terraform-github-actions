

# 09-eks-lab

- Projeto usando eks-blueprint
https://catalog.workshops.aws/eks-blueprints-terraform/en-US/030-provision-eks-cluster/1-create-a-terraform-project



## RESUMO

- COMANDOS
terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks_blueprints -auto-approve
terraform apply -target=module.kubernetes_addons -auto-approve
terraform apply -auto-approve

terraform destroy -target=module.kubernetes_addons -auto-approve
terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve


## SOLUÇÃO
- Para usuários comuns, adicionar o arn do usuário normal.
- Para usuário root, adicionar arn "arn:aws:iam::261106957109:root" ao invés do arn do usuário com nome do usuário.

## Obs
- Seguir o README no Apply e no Destroy.
- Cuidar extensão do nome(no locals.tf), para não formar um nome muito longo ao recurso.


## INFO

- Projeto sobe EKS + Prometheus + Grafana + AlertManager


# Subindo o projeto

## Permissões

- Para o acesso ao Prometheus ocorrer corretamente via navegador, é necessário liberar a porta 30090 do NodePort na SG da EC2 do EKS.
nodePort: 30090

- Ao liberar a porta na SG que atende as EC2 do node-group, ela fica acessível via navegador, por exemplo:
44.200.210.199:30090
http://44.200.210.199:30090/alerts?search=
<http://44.200.210.199:30090/alerts?search=>

- Até o momento, não foi encontrada maneira de liberar os ips e portas das SG das EC2 dos node-group via Terraform.


## Port-forward

PROMETHEUS
- Somente para teste direto num Pod, devido o uso de NodePort já é acessível externamente.

GRAFANA
Acesso local usando Port-forward
kubectl get pods --selector app.kubernetes.io/name=grafana -n kube-prometheus-stack -o=name
kubectl port-forward $(kubectl get pods --selector app.kubernetes.io/name=grafana -n kube-prometheus-stack -o=name) -n kube-prometheus-stack --address 0.0.0.0 8080:3000

- Acessível:
192.168.0.110:8080
<192.168.0.110:8080>

# Particularidades

- Os nodes públicos são provisionados com o trecho do "managed_node_groups" no main.tf, devido a linha abaixo, para que o Prometheus fique acessível externamente:
subnet_ids      = module.vpc.public_subnets

## Usuários

- Para permitir usuários comuns, adicionar o arn do usuário normal.
- Para permitir um usuário IAM que é root, adicionar arn "arn:aws:iam::261106957109:root" ao invés do arn do usuário com nome do usuário.

## Tutoriais

- Tutorial explicando como adicionar a Stack do Prometheus via Addons:
eks-via-terraform-github-actions/09-eks-blueprint/material-de-apoio/Metrics-with-Blueprints-addons-kube-prometheus-stack.md

- Tutorial explicando como personalizar o Helm Chart do Prometheus
eks-via-terraform-github-actions/09-eks-blueprint/material-de-apoio/Helm-Prometheus-kube-stack-Como-editar.md

## Outras observações

- Seguir a ordem correta no Apply e no Destroy, para que não ocorra de alguns recursos ficarem impedidos de serem excluídos depois.
- Cuidar extensão do nome(no locals.tf), para não formar um nome muito longo ao recurso, causando alguns problemas, que podem dificultar a criação ou exclusão de recursos.

## PROMETHEUS

- Foram usados os addons de Prometheus(kube-prometheus-stack) para subir o Prometheus, Grafana e AlertManager:
https://catalog.workshops.aws/eks-blueprints-terraform/en-US/050-observability/2-metrics-kube-prometheus-stack#metrics-with-kube-prometheus-stack
https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

- Port-forward
kubectl get pods --selector app.kubernetes.io/name=grafana -n kube-prometheus-stack -o=name
kubectl port-forward $(kubectl get pods --selector app.kubernetes.io/name=grafana -n kube-prometheus-stack -o=name) -n kube-prometheus-stack --address 0.0.0.0 8080:3000

- Senha do Grafana:
prom-operator



----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

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









Get the Prometheus server URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace prometheus -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace prometheus port-forward $POD_NAME 9090



Get the Alertmanager URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace prometheus -l "app=prometheus,component=" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace prometheus port-forward $POD_NAME 9093



kubectl get pods --namespace prometheus
kubectl get all --namespace prometheus


~~~~bash

fernando@debian10x64:~$ kubectl get pods --namespace prometheus
NAME                                                 READY   STATUS    RESTARTS   AGE
prometheus-alertmanager-0                            0/1     Pending   0          3m25s
prometheus-kube-state-metrics-5d888875ff-tfbtg       1/1     Running   0          3m25s
prometheus-prometheus-node-exporter-475t9            1/1     Running   0          3m25s
prometheus-prometheus-node-exporter-7sdpr            1/1     Running   0          3m25s
prometheus-prometheus-node-exporter-d2582            1/1     Running   0          3m25s
prometheus-prometheus-pushgateway-6445c657fc-4fr9x   1/1     Running   0          3m25s
prometheus-server-5fc6895768-s8cbc                   0/2     Pending   0          3m25s
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$ kubectl get all --namespace prometheus
NAME                                                     READY   STATUS    RESTARTS   AGE
pod/prometheus-alertmanager-0                            0/1     Pending   0          3m55s
pod/prometheus-kube-state-metrics-5d888875ff-tfbtg       1/1     Running   0          3m55s
pod/prometheus-prometheus-node-exporter-475t9            1/1     Running   0          3m55s
pod/prometheus-prometheus-node-exporter-7sdpr            1/1     Running   0          3m55s
pod/prometheus-prometheus-node-exporter-d2582            1/1     Running   0          3m55s
pod/prometheus-prometheus-pushgateway-6445c657fc-4fr9x   1/1     Running   0          3m55s
pod/prometheus-server-5fc6895768-s8cbc                   0/2     Pending   0          3m55s

NAME                                          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/prometheus-alertmanager               ClusterIP   172.20.47.77     <none>        9093/TCP   3m56s
service/prometheus-alertmanager-headless      ClusterIP   None             <none>        9093/TCP   3m56s
service/prometheus-kube-state-metrics         ClusterIP   172.20.63.159    <none>        8080/TCP   3m56s
service/prometheus-prometheus-node-exporter   ClusterIP   172.20.29.203    <none>        9100/TCP   3m56s
service/prometheus-prometheus-pushgateway     ClusterIP   172.20.126.248   <none>        9091/TCP   3m56s
service/prometheus-server                     ClusterIP   172.20.124.28    <none>        80/TCP     3m56s

NAME                                                 DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/prometheus-prometheus-node-exporter   3         3         3       3            3           <none>          3m56s

NAME                                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/prometheus-kube-state-metrics       1/1     1            1           3m56s
deployment.apps/prometheus-prometheus-pushgateway   1/1     1            1           3m56s
deployment.apps/prometheus-server                   0/1     1            0           3m56s

NAME                                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/prometheus-kube-state-metrics-5d888875ff       1         1         1       3m56s
replicaset.apps/prometheus-prometheus-pushgateway-6445c657fc   1         1         1       3m56s
replicaset.apps/prometheus-server-5fc6895768                   1         1         0       3m56s

NAME                                       READY   AGE
statefulset.apps/prometheus-alertmanager   0/1     3m56s
fernando@debian10x64:~$

~~~~







fernando@debian10x64:~$ export POD_NAME=$(kubectl get pods --namespace prometheus -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$ kubectl --namespace prometheus port-forward $POD_NAME 9090
error: unable to forward port because pod is not running. Current status=Pending
fernando@debian10x64:~$


kubectl describe pod prometheus-server-5fc6895768-s8cbc --namespace prometheus
prometheus-server-5fc6895768-s8cbc
kubectl get pod prometheus-server-5fc6895768-s8cbc --namespace prometheus


fernando@debian10x64:~$ kubectl get pod prometheus-server-5fc6895768-s8cbc --namespace prometheus
NAME                                 READY   STATUS    RESTARTS   AGE
prometheus-server-5fc6895768-s8cbc   0/2     Pending   0          6m53s
fernando@debian10x64:~$


kubectl logs prometheus-server-5fc6895768-s8cbc --namespace prometheus













I had same issues as you. I found two ways to solve this:

    edit values.yaml under persistentVolumes.enabled=false this will allow you to use emptyDir "this applies to Prometheus-Server and AlertManager"

    If you can't change values.yaml you will have to create the PV before deploying the chart so that the pod can bind to the volume otherwise it will stay in the pending state forever






fernando@debian10x64:~$ helm ls -A
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
prometheus      prometheus      1               2023-04-08 22:07:24.961575886 -0300 -03 deployed        prometheus-20.0.2       v2.43.0
fernando@debian10x64:~$ helm uninstall prometheus -n prometheus
release "prometheus" uninstalled
fernando@debian10x64:~$





kubectl create namespace prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade -i prometheus prometheus-community/prometheus \
    --namespace prometheus \
    --set persistentVolumes.enabled=false








fernando@debian10x64:~$ kubectl get pv --namespace prometheus
No resources found
fernando@debian10x64:~$ kubectl get pvc --namespace prometheus
NAME                                STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
prometheus-server                   Pending                                      gp2            57s
storage-prometheus-alertmanager-0   Pending                                      gp2            15m
fernando@debian10x64:~$







helm upgrade meu-ingress-controller ingress-nginx/ingress-nginx --namespace nginx-ingress --values values.yaml	Atualizar informações dos recursos via comando Upgrade	Upgrade	Release



helm upgrade -i prometheus prometheus-community/prometheus \
    --namespace prometheus \
    --values /home/fernando/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint/helm-editado/values_v1.yaml



fernando@debian10x64:~$ helm upgrade -i prometheus prometheus-community/prometheus \
>     --namespace prometheus \
>     --values /home/fernando/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint/helm-editado/values_v1.yaml
Release "prometheus" has been upgraded. Happy Helming!
NAME: prometheus
LAST DEPLOYED: Sat Apr  8 22:31:28 2023
NAMESPACE: prometheus
STATUS: deployed
REVISION: 2






- Subiu o Prometheus Server
- Não subiu o AlertManager

kubectl get pods --namespace prometheus
kubectl get all --namespace prometheus

~~~~bash

fernando@debian10x64:~$ kubectl get pods --namespace prometheus

NAME                                                 READY   STATUS    RESTARTS   AGE
prometheus-alertmanager-0                            0/1     Pending   0          10m
prometheus-kube-state-metrics-5d888875ff-xrmgm       1/1     Running   0          10m
prometheus-prometheus-node-exporter-ctz5z            1/1     Running   0          10m
prometheus-prometheus-node-exporter-p2xrb            1/1     Running   0          10m
prometheus-prometheus-node-exporter-xllms            1/1     Running   0          10m
prometheus-prometheus-pushgateway-6445c657fc-ljj5f   1/1     Running   0          10m
prometheus-server-8d48c685-58kpw                     2/2     Running   0          62s
fernando@debian10x64:~$ kubectl get all --namespace prometheus
NAME                                                     READY   STATUS    RESTARTS   AGE
pod/prometheus-alertmanager-0                            0/1     Pending   0          10m
pod/prometheus-kube-state-metrics-5d888875ff-xrmgm       1/1     Running   0          10m
pod/prometheus-prometheus-node-exporter-ctz5z            1/1     Running   0          10m
pod/prometheus-prometheus-node-exporter-p2xrb            1/1     Running   0          10m
pod/prometheus-prometheus-node-exporter-xllms            1/1     Running   0          10m
pod/prometheus-prometheus-pushgateway-6445c657fc-ljj5f   1/1     Running   0          10m
pod/prometheus-server-8d48c685-58kpw                     2/2     Running   0          64s

NAME                                          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/prometheus-alertmanager               ClusterIP   172.20.36.53     <none>        9093/TCP   10m
service/prometheus-alertmanager-headless      ClusterIP   None             <none>        9093/TCP   10m
service/prometheus-kube-state-metrics         ClusterIP   172.20.232.0     <none>        8080/TCP   10m
service/prometheus-prometheus-node-exporter   ClusterIP   172.20.225.180   <none>        9100/TCP   10m
service/prometheus-prometheus-pushgateway     ClusterIP   172.20.244.106   <none>        9091/TCP   10m
service/prometheus-server                     ClusterIP   172.20.163.226   <none>        80/TCP     10m

NAME                                                 DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/prometheus-prometheus-node-exporter   3         3         3       3            3           <none>          10m

NAME                                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/prometheus-kube-state-metrics       1/1     1            1           10m
deployment.apps/prometheus-prometheus-pushgateway   1/1     1            1           10m
deployment.apps/prometheus-server                   1/1     1            1           10m

NAME                                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/prometheus-kube-state-metrics-5d888875ff       1         1         1       10m
replicaset.apps/prometheus-prometheus-pushgateway-6445c657fc   1         1         1       10m
replicaset.apps/prometheus-server-5fc6895768                   0         0         0       10m
replicaset.apps/prometheus-server-8d48c685                     1         1         1       65s

NAME                                       READY   AGE
statefulset.apps/prometheus-alertmanager   0/1     10m
fernando@debian10x64:~$ ^C

~~~~














- Verificando o values do AlertManager antes:

~~~~YAML

fernando@debian10x64:~$ helm show values prometheus-community/alertmanager
# Default values for alertmanager.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

replicaCount: 1

image:
  repository: quay.io/prometheus/alertmanager
  pullPolicy: IfNotPresent
  # Overrides the image tag whose default is the chart appVersion.
  tag: ""

extraArgs: {}

## Additional Alertmanager Secret mounts
# Defines additional mounts with secrets. Secrets must be manually created in the namespace.
extraSecretMounts: []
  # - name: secret-files
  #   mountPath: /etc/secrets
  #   subPath: ""
  #   secretName: alertmanager-secret-files
  #   readOnly: true

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

automountServiceAccountToken: true

serviceAccount:
  # Specifies whether a service account should be created
  create: true
  # Annotations to add to the service account
  annotations: {}
  # The name of the service account to use.
  # If not set and create is true, a name is generated using the fullname template
  name:

# Sets priorityClassName in alertmanager pod
priorityClassName: ""

podSecurityContext:
  fsGroup: 65534
dnsConfig: {}
  # nameservers:
  #   - 1.2.3.4
  # searches:
  #   - ns1.svc.cluster-domain.example
  #   - my.dns.search.suffix
  # options:
  #   - name: ndots
  #     value: "2"
  #   - name: edns0
securityContext:
  # capabilities:
  #   drop:
  #   - ALL
  # readOnlyRootFilesystem: true
  runAsUser: 65534
  runAsNonRoot: true
  runAsGroup: 65534

additionalPeers: []

## Additional InitContainers to initialize the pod
##
extraInitContainers: []

livenessProbe:
  httpGet:
    path: /
    port: http

readinessProbe:
  httpGet:
    path: /
    port: http

service:
  annotations: {}
  type: ClusterIP
  port: 9093
  clusterPort: 9094
  loadBalancerIP: ""  # Assign ext IP when Service type is LoadBalancer
  loadBalancerSourceRanges: []  # Only allow access to loadBalancerIP from these IPs
  # if you want to force a specific nodePort. Must be use with service.type=NodePort
  # nodePort:

ingress:
  enabled: false
  className: ""
  annotations: {}
    # kubernetes.io/ingress.class: nginx
    # kubernetes.io/tls-acme: "true"
  hosts:
    - host: alertmanager.domain.com
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls: []
  #  - secretName: chart-example-tls
  #    hosts:
  #      - alertmanager.domain.com

resources: {}
  # We usually recommend not to specify default resources and to leave this as a conscious
  # choice for the user. This also increases chances charts run on environments with little
  # resources, such as Minikube. If you do want to specify resources, uncomment the following
  # lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  # limits:
  #   cpu: 100m
  #   memory: 128Mi
  # requests:
  #   cpu: 10m
  #   memory: 32Mi

nodeSelector: {}

tolerations: []

affinity: {}

## Pod anti-affinity can prevent the scheduler from placing Alertmanager replicas on the same node.
## The default value "soft" means that the scheduler should *prefer* to not schedule two replica pods onto the same node but no guarantee is provided.
## The value "hard" means that the scheduler is *required* to not schedule two replica pods onto the same node.
## The value "" will disable pod anti-affinity so that no anti-affinity rules will be configured.
##
podAntiAffinity: ""

## If anti-affinity is enabled sets the topologyKey to use for anti-affinity.
## This can be changed to, for example, failure-domain.beta.kubernetes.io/zone
##
podAntiAffinityTopologyKey: kubernetes.io/hostname

## Topology spread constraints rely on node labels to identify the topology domain(s) that each Node is in.
## Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
topologySpreadConstraints: []
  # - maxSkew: 1
  #   topologyKey: failure-domain.beta.kubernetes.io/zone
  #   whenUnsatisfiable: DoNotSchedule
  #   labelSelector:
  #     matchLabels:
  #       app.kubernetes.io/instance: alertmanager

statefulSet:
  annotations: {}

podAnnotations: {}
podLabels: {}

# Ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/
podDisruptionBudget: {}
  # maxUnavailable: 1
  # minAvailable: 1

command: []

persistence:
  enabled: true
  ## Persistent Volume Storage Class
  ## If defined, storageClassName: <storageClass>
  ## If set to "-", storageClassName: "", which disables dynamic provisioning
  ## If undefined (the default) or set to null, no storageClassName spec is
  ## set, choosing the default provisioner.
  ##
  # storageClass: "-"
  accessModes:
    - ReadWriteOnce
  size: 50Mi

config:
  global: {}
    # slack_api_url: ''

  templates:
    - '/etc/alertmanager/*.tmpl'

  receivers:
    - name: default-receiver
      # slack_configs:
      #  - channel: '@you'
      #    send_resolved: true

  route:
    group_wait: 10s
    group_interval: 5m
    receiver: default-receiver
    repeat_interval: 3h

## Monitors ConfigMap changes and POSTs to a URL
## Ref: https://github.com/jimmidyson/configmap-reload
##
configmapReload:
  ## If false, the configmap-reload container will not be deployed
  ##
  enabled: false

  ## configmap-reload container name
  ##
  name: configmap-reload

  ## configmap-reload container image
  ##
  image:
    repository: jimmidyson/configmap-reload
    tag: v0.8.0
    pullPolicy: IfNotPresent

  # containerPort: 9533

  ## configmap-reload resource requests and limits
  ## Ref: http://kubernetes.io/docs/user-guide/compute-resources/
  ##
  resources: {}

templates: {}
#   alertmanager.tmpl: |-

## Optionally specify extra list of additional volumeMounts
extraVolumeMounts: []
  # - name: extras
  #   mountPath: /usr/share/extras
  #   readOnly: true

## Optionally specify extra list of additional volumes
extraVolumes: []
  # - name: extras
  #   emptyDir: {}

## Optionally specify extra environment variables to add to alertmanager container
extraEnv: []
  # - name: FOO
  #   value: BAR

fernando@debian10x64:~$

~~~~











- Ajustando:
/home/fernando/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint/helm-editado/values_v2.yaml

~~~~YAML

## alertmanager sub-chart configurable values
## Please see https://github.com/prometheus-community/helm-charts/tree/main/charts/alertmanager
##
alertmanager:
  ## If false, alertmanager will not be installed
  ##
  enabled: true

  persistence:
    enabled: false
~~~~



helm upgrade -i prometheus prometheus-community/prometheus \
    --namespace prometheus \
    --values /home/fernando/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint/helm-editado/values_v2.yaml


fernando@debian10x64:~$ helm upgrade -i prometheus prometheus-community/prometheus \
>     --namespace prometheus \
>     --values /home/fernando/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint/helm-editado/values_v2.yaml
Error: UPGRADE FAILED: cannot patch "prometheus-alertmanager" with kind StatefulSet: StatefulSet.apps "prometheus-alertmanager" is invalid: spec: Forbidden: updates to statefulset spec for fields other than 'replicas', 'template', 'updateStrategy', 'persistentVolumeClaimRetentionPolicy' and 'minReadySeconds' are forbidden
fernando@debian10x64:~$



helm uninstall prometheus --namespace prometheus
fernando@debian10x64:~$ helm uninstall prometheus --namespace prometheus
release "prometheus" uninstalled
fernando@debian10x64:~$



helm upgrade -i prometheus prometheus-community/prometheus \
    --namespace prometheus \
    --values /home/fernando/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint/helm-editado/values_v2.yaml





kubectl get pods --namespace prometheus
kubectl get all --namespace prometheus



- Agora subiram todos os Pods, usando a v2 do values:

~~~~bash

fernando@debian10x64:~$ kubectl get pods --namespace prometheus

NAME                                                 READY   STATUS    RESTARTS   AGE
prometheus-alertmanager-0                            1/1     Running   0          18s
prometheus-kube-state-metrics-5d888875ff-449sh       1/1     Running   0          18s
prometheus-prometheus-node-exporter-mqcm4            1/1     Running   0          18s
prometheus-prometheus-node-exporter-sfh67            1/1     Running   0          18s
prometheus-prometheus-node-exporter-xfv7p            1/1     Running   0          18s
prometheus-prometheus-pushgateway-6445c657fc-98jbs   0/1     Running   0          18s
prometheus-server-8d48c685-pccz8                     1/2     Running   0          18s
fernando@debian10x64:~$ kubectl get all --namespace prometheus
NAME                                                     READY   STATUS    RESTARTS   AGE
pod/prometheus-alertmanager-0                            1/1     Running   0          20s
pod/prometheus-kube-state-metrics-5d888875ff-449sh       1/1     Running   0          20s
pod/prometheus-prometheus-node-exporter-mqcm4            1/1     Running   0          20s
pod/prometheus-prometheus-node-exporter-sfh67            1/1     Running   0          20s
pod/prometheus-prometheus-node-exporter-xfv7p            1/1     Running   0          20s
pod/prometheus-prometheus-pushgateway-6445c657fc-98jbs   0/1     Running   0          20s
pod/prometheus-server-8d48c685-pccz8                     1/2     Running   0          20s

NAME                                          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/prometheus-alertmanager               ClusterIP   172.20.81.52     <none>        9093/TCP   21s
service/prometheus-alertmanager-headless      ClusterIP   None             <none>        9093/TCP   21s
service/prometheus-kube-state-metrics         ClusterIP   172.20.254.89    <none>        8080/TCP   21s
service/prometheus-prometheus-node-exporter   ClusterIP   172.20.101.207   <none>        9100/TCP   21s
service/prometheus-prometheus-pushgateway     ClusterIP   172.20.179.43    <none>        9091/TCP   21s
service/prometheus-server                     ClusterIP   172.20.236.225   <none>        80/TCP     21s

NAME                                                 DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/prometheus-prometheus-node-exporter   3         3         3       3            3           <none>          20s

NAME                                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/prometheus-kube-state-metrics       1/1     1            1           21s
deployment.apps/prometheus-prometheus-pushgateway   1/1     1            1           21s
deployment.apps/prometheus-server                   0/1     1            0           21s

NAME                                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/prometheus-kube-state-metrics-5d888875ff       1         1         1       21s
replicaset.apps/prometheus-prometheus-pushgateway-6445c657fc   1         1         1       21s
replicaset.apps/prometheus-server-8d48c685                     1         1         0       21s

NAME                                       READY   AGE
statefulset.apps/prometheus-alertmanager   1/1     21s
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$ kubectl get pods --namespace prometheus
NAME                                                 READY   STATUS    RESTARTS   AGE
prometheus-alertmanager-0                            1/1     Running   0          36s
prometheus-kube-state-metrics-5d888875ff-449sh       1/1     Running   0          36s
prometheus-prometheus-node-exporter-mqcm4            1/1     Running   0          36s
prometheus-prometheus-node-exporter-sfh67            1/1     Running   0          36s
prometheus-prometheus-node-exporter-xfv7p            1/1     Running   0          36s
prometheus-prometheus-pushgateway-6445c657fc-98jbs   1/1     Running   0          36s
prometheus-server-8d48c685-pccz8                     1/2     Running   0          36s
fernando@debian10x64:~$
fernando@debian10x64:~$ date
Sat 08 Apr 2023 10:46:03 PM -03
fernando@debian10x64:~$

~~~~














# PENDENTE

## Material de apoio:
- Values de referencia:
/home/fernando/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint/bkp-antes/values.yaml

- Chart do Prometheus
https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus

## Continuar em:
- Expor Prometheus ao mundo, verificar como fazer para expor o Prometheus que está no AWS EKS.
expondo via service:
https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/user-guides/exposing-prometheus-and-alertmanager.md
Necessário ajustar o cluster EKS, para que tenha Nodes publicos numa Subnet Publica, para ter um External IP.

- Quando utilizando Persistence, os Pods do Prometheus-Server e do AlertManager não sobem.
Pode ser devido o GP2 e o PVC que eles tentam utilizar.
Tentar aplicar solução, criando o PVC tbm:
https://stackoverflow.com/questions/47235014/why-prometheus-pod-pending-after-setup-it-by-helm-in-kubernetes-cluster-on-ranch
<https://stackoverflow.com/questions/47235014/why-prometheus-pod-pending-after-setup-it-by-helm-in-kubernetes-cluster-on-ranch>

- Helm via Terraform, verificar como fazer o Terraform aplicar o chart do Prometheus.
usar o values personalizado.






~~~~bash
Get the Prometheus server URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace prometheus -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace prometheus port-forward $POD_NAME 9090
#################################################################################
######   WARNING: Persistence is disabled!!! You will lose your data when   #####
######            the Server pod is terminated.                             #####
#################################################################################
~~~~


- Expondo via port-forward:

~~~~bash
fernando@debian10x64:~$ export POD_NAME=$(kubectl get pods --namespace prometheus -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
fernando@debian10x64:~$   kubectl --namespace prometheus port-forward $POD_NAME 9090
Forwarding from 127.0.0.1:9090 -> 9090
Forwarding from [::1]:9090 -> 9090
Handling connection for 9090
Handling connection for 9090
Handling connection for 9090
Handling connection for 9090
~~~~



- Acessível via VM do Debian:
http://localhost:9090



- Não é possível acessar via:
http://192.168.92.129:9090
http://192.168.0.110:9090





- Services

~~~~bash
fernando@debian10x64:~$ kubectl get svc -n prometheus
NAME                                  TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
prometheus-alertmanager               ClusterIP   172.20.81.52     <none>        9093/TCP   74m
prometheus-alertmanager-headless      ClusterIP   None             <none>        9093/TCP   74m
prometheus-kube-state-metrics         ClusterIP   172.20.254.89    <none>        8080/TCP   74m
prometheus-prometheus-node-exporter   ClusterIP   172.20.101.207   <none>        9100/TCP   74m
prometheus-prometheus-pushgateway     ClusterIP   172.20.179.43    <none>        9091/TCP   74m
prometheus-server                     ClusterIP   172.20.236.225   <none>        80/TCP     74m
fernando@debian10x64:~$
~~~~




/home/fernando/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint/helm-editado/values_v3.yaml

DE:
    type: ClusterIP
PARA:
    type: nodePort


helm upgrade -i prometheus prometheus-community/prometheus \
    --namespace prometheus \
    --values /home/fernando/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint/helm-editado/values_v3.yaml


- Erro


fernando@debian10x64:~$ helm upgrade -i prometheus prometheus-community/prometheus \
>     --namespace prometheus \
>     --values /home/fernando/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint/helm-editado/values_v3.yaml
Error: UPGRADE FAILED: cannot patch "prometheus-server" with kind Service: Service "prometheus-server" is invalid: spec.type: Unsupported value: "nodePort": supported values: "ClusterIP", "ExternalName", "LoadBalancer", "NodePort"
fernando@debian10x64:~$




- Ajustando

/home/fernando/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint/helm-editado/values_v3.yaml

DE:
    type: nodePort
PARA:
    type: NodePort



~~~~bash

fernando@debian10x64:~$ helm upgrade -i prometheus prometheus-community/prometheus     --namespace prometheus     --values /home/fernando/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint/helm-editado/values_v3.yaml
Release "prometheus" has been upgraded. Happy Helming!
NAME: prometheus
LAST DEPLOYED: Sun Apr  9 00:12:34 2023
NAMESPACE: prometheus
STATUS: deployed
REVISION: 3
NOTES:
The Prometheus server can be accessed via port 80 on the following DNS name from within your cluster:
prometheus-server.prometheus.svc.cluster.local


Get the Prometheus server URL by running these commands in the same shell:
  export NODE_PORT=$(kubectl get --namespace prometheus -o jsonpath="{.spec.ports[0].nodePort}" services prometheus-server)
  export NODE_IP=$(kubectl get nodes --namespace prometheus -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT
#################################################################################
######   WARNING: Persistence is disabled!!! You will lose your data when   #####
######            the Server pod is terminated.                             #####
#################################################################################


The Prometheus alertmanager can be accessed via port  on the following DNS name from within your cluster:
prometheus-%!s(<nil>).prometheus.svc.cluster.local


Get the Alertmanager URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace prometheus -l "app=prometheus,component=" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace prometheus port-forward $POD_NAME 9093
#################################################################################
######   WARNING: Persistence is disabled!!! You will lose your data when   #####
######            the AlertManager pod is terminated.                       #####
#################################################################################
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


fernando@debian10x64:~$ kubectl get svc -n prometheus
NAME                                  TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
prometheus-alertmanager               ClusterIP   172.20.81.52     <none>        9093/TCP       87m
prometheus-alertmanager-headless      ClusterIP   None             <none>        9093/TCP       87m
prometheus-kube-state-metrics         ClusterIP   172.20.254.89    <none>        8080/TCP       87m
prometheus-prometheus-node-exporter   ClusterIP   172.20.101.207   <none>        9100/TCP       87m
prometheus-prometheus-pushgateway     ClusterIP   172.20.179.43    <none>        9091/TCP       87m
prometheus-server                     NodePort    172.20.236.225   <none>        80:32259/TCP   87m
fernando@debian10x64:~$ date
Sun 09 Apr 2023 12:12:58 AM -03
fernando@debian10x64:~$
~~~~







Get the Prometheus server URL by running these commands in the same shell:
  export NODE_PORT=$(kubectl get --namespace prometheus -o jsonpath="{.spec.ports[0].nodePort}" services prometheus-server)
  export NODE_IP=$(kubectl get nodes --namespace prometheus -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT




fernando@debian10x64:~$   export NODE_PORT=$(kubectl get --namespace prometheus -o jsonpath="{.spec.ports[0].nodePort}" services prometheus-server)
fernando@debian10x64:~$   export NODE_IP=$(kubectl get nodes --namespace prometheus -o jsonpath="{.items[0].status.addresses[0].address}")
fernando@debian10x64:~$   echo http://$NODE_IP:$NODE_PORT
http://10.0.10.136:32259
fernando@debian10x64:~$



- Expos o ip privado


fernando@debian10x64:~$ kubectl get nodes
NAME                          STATUS   ROLES    AGE    VERSION
ip-10-0-10-136.ec2.internal   Ready    <none>   171m   v1.23.17-eks-a59e1f0
ip-10-0-11-122.ec2.internal   Ready    <none>   171m   v1.23.17-eks-a59e1f0
ip-10-0-12-160.ec2.internal   Ready    <none>   171m   v1.23.17-eks-a59e1f0
fernando@debian10x64:~$

fernando@debian10x64:~$ kubectl get nodes -o wide
NAME                          STATUS   ROLES    AGE    VERSION                INTERNAL-IP   EXTERNAL-IP   OS-IMAGE         KERNEL-VERSION                 CONTAINER-RUNTIME
ip-10-0-10-136.ec2.internal   Ready    <none>   171m   v1.23.17-eks-a59e1f0   10.0.10.136   <none>        Amazon Linux 2   5.4.238-148.346.amzn2.x86_64   docker://20.10.17
ip-10-0-11-122.ec2.internal   Ready    <none>   171m   v1.23.17-eks-a59e1f0   10.0.11.122   <none>        Amazon Linux 2   5.4.238-148.346.amzn2.x86_64   docker://20.10.17
ip-10-0-12-160.ec2.internal   Ready    <none>   171m   v1.23.17-eks-a59e1f0   10.0.12.160   <none>        Amazon Linux 2   5.4.238-148.346.amzn2.x86_64   docker://20.10.17
fernando@debian10x64:~$








- Testar "public_subnets" no eks blueprint



- Troquei onde tinha private por public:
private_subnet_ids = module.vpc.private_subnets
subnet_ids      = module.vpc.private_subnets

- Erro

~~~~bash
module.eks_blueprints.module.aws_eks.aws_eks_cluster.this[0]: Refreshing state... [id=eks-lab]
╷
│ Error: Error in function call
│
│   on .terraform/modules/eks_blueprints.aws_eks/main.tf line 24, in resource "aws_eks_cluster" "this":
│   24:     subnet_ids              = coalescelist(var.control_plane_subnet_ids, var.subnet_ids)
│     ├────────────────
│     │ var.control_plane_subnet_ids is empty list of string
│     │ var.subnet_ids is empty list of string
│
│ Call to function "coalescelist" failed: no non-null arguments.
╵
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$
~~~~




- Adicionando node-group separado para os public:

    T3A_NODE2 = {
      node_group_name = "teste2"
      instance_types  = ["t3a.medium"]
      subnet_ids      = module.vpc.public_subnets
    }




- Aplicado


module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_NODE2"].aws_eks_node_group.managed_ng: Still creating... [4m20s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_NODE2"].aws_eks_node_group.managed_ng: Still creating... [4m30s elapsed]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_NODE2"].aws_eks_node_group.managed_ng: Creation complete after 4m35s [id=eks-lab:teste2-20230409032905072200000005]

Apply complete! Resources: 7 added, 1 changed, 0 destroyed.

Outputs:

configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-0a522b806f302ae0a"
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$






  export NODE_PORT=$(kubectl get --namespace prometheus -o jsonpath="{.spec.ports[0].nodePort}" services prometheus-server)
  export NODE_IP=$(kubectl get nodes --namespace prometheus -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT




fernando@debian10x64:~$ kubectl get nodes -o wide
NAME                          STATUS   ROLES    AGE     VERSION                INTERNAL-IP   EXTERNAL-IP     OS-IMAGE         KERNEL-VERSION                 CONTAINER-RUNTIME
ip-10-0-0-11.ec2.internal     Ready    <none>   4m5s    v1.23.17-eks-a59e1f0   10.0.0.11     3.231.164.18    Amazon Linux 2   5.4.238-148.346.amzn2.x86_64   docker://20.10.17
ip-10-0-1-112.ec2.internal    Ready    <none>   4m6s    v1.23.17-eks-a59e1f0   10.0.1.112    3.80.182.168    Amazon Linux 2   5.4.238-148.346.amzn2.x86_64   docker://20.10.17
ip-10-0-10-136.ec2.internal   Ready    <none>   3h11m   v1.23.17-eks-a59e1f0   10.0.10.136   <none>          Amazon Linux 2   5.4.238-148.346.amzn2.x86_64   docker://20.10.17
ip-10-0-11-122.ec2.internal   Ready    <none>   3h11m   v1.23.17-eks-a59e1f0   10.0.11.122   <none>          Amazon Linux 2   5.4.238-148.346.amzn2.x86_64   docker://20.10.17
ip-10-0-12-160.ec2.internal   Ready    <none>   3h11m   v1.23.17-eks-a59e1f0   10.0.12.160   <none>          Amazon Linux 2   5.4.238-148.346.amzn2.x86_64   docker://20.10.17
ip-10-0-2-69.ec2.internal     Ready    <none>   4m5s    v1.23.17-eks-a59e1f0   10.0.2.69     54.204.253.27   Amazon Linux 2   5.4.238-148.346.amzn2.x86_64   docker://20.10.17
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$   export NODE_PORT=$(kubectl get --namespace prometheus -o jsonpath="{.spec.ports[0].nodePort}" services prometheus-server)

fernando@debian10x64:~$   export NODE_IP=$(kubectl get nodes --namespace prometheus -o jsonpath="{.items[0].status.addresses[0].address}")
fernando@debian10x64:~$   echo http://$NODE_IP:$NODE_PORT
http://10.0.0.11:32259
fernando@debian10x64:~$
fernando@debian10x64:~$


- Não acessou via:
http://3.231.164.18:32259


- Pod do Server tá no Node:
ip-10-0-10-136.ec2.internal
esse node é privado













- Efetuando destroy

terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve






----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

# PENDENTE

## Material de apoio:
- Values de referencia:
/home/fernando/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint/bkp-antes/values.yaml

- Chart do Prometheus
https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus

## Continuar em:

- Expor Prometheus ao mundo, verificar como fazer para expor o Prometheus que está no AWS EKS.
expondo via service:
https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/user-guides/exposing-prometheus-and-alertmanager.md
Necessário ajustar o cluster EKS, para que tenha Nodes publicos numa Subnet Publica, para ter um External IP.
Avaliar se criar Cluster EKS só com o Node-group de Subnet Publica ou expor via Ingress(verificar como).

Expor o Prometheus via Ingress ao invés de Port-Forward

- Persistencia, ver melhor maneira e erros ocorridos.
- Quando utilizando Persistence, os Pods do Prometheus-Server e do AlertManager não sobem.
Pode ser devido o GP2 e o PVC que eles tentam utilizar.
Tentar aplicar solução, criando o PVC tbm:
https://stackoverflow.com/questions/47235014/why-prometheus-pod-pending-after-setup-it-by-helm-in-kubernetes-cluster-on-ranch
<https://stackoverflow.com/questions/47235014/why-prometheus-pod-pending-after-setup-it-by-helm-in-kubernetes-cluster-on-ranch>

- Helm via Terraform, verificar como fazer o Terraform aplicar o chart do Prometheus.
usar o values personalizado.







# Dia 15/04/2023

- Expor o Prometheus via Ingress ao invés de Port-Forward

- Subindo EKS

terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks_blueprints -auto-approve
terraform apply -auto-approve


19:34h
terraform apply -target=module.eks_blueprints -auto-approve



configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-09c7f99a7574131f7"


- Comentando o node-group "T3A_NODE2" no manifesto main.tf, para remover as maquinas das Subnets Publicas:
"T3A_NODE2"
eks-via-terraform-github-actions/09-eks-blueprint/main.tf
~~~~h
#    T3A_NODE2 = {
#      node_group_name = "teste2"
#      instance_types  = ["t3a.medium"]
#      subnet_ids      = module.vpc.public_subnets
#    }
~~~~






- Expor o Prometheus via Ingress ao invés de Port-Forward



- Via Blueprint

https://catalog.workshops.aws/eks-blueprints-terraform/en-US/050-observability/2-metrics-kube-prometheus-stack
<https://catalog.workshops.aws/eks-blueprints-terraform/en-US/050-observability/2-metrics-kube-prometheus-stack>

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



- Editando

~~~~h
module "kubernetes_addons" {
source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.21.0/modules/kubernetes-addons"
  enable_aws_load_balancer_controller  = true
  enable_amazon_eks_aws_ebs_csi_driver = true
  enable_metrics_server                = true
  enable_kube_prometheus_stack         = true # <-- Add this line
}
~~~~




- Aplicando:
terraform apply -target=module.kubernetes_addons -auto-approve

- Erro durante apply:

~~~~bash
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ terraform apply -target=module.kubernetes_addons -auto-approve
╷
│ Error: Missing required argument
│
│   on main.tf line 270, in module "kubernetes_addons":
│  270: module "kubernetes_addons" {
│
│ The argument "eks_cluster_id" is required, but no definition was found.
╵
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$
~~~~



- Detalhes
https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
<https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack>



- Adicionada a linha abaixo, para resolver o erro:
eks_cluster_id                = module.eks_blueprints.eks_cluster_id


- Aplicado:

~~~~bash

module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still creating... [2m20s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still creating... [2m30s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still creating... [2m40s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still creating... [2m50s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still creating... [3m0s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Creation complete after 3m2s [id=kube-prometheus-stack]
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

Apply complete! Resources: 13 added, 0 changed, 0 destroyed.

Outputs:

configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-09c7f99a7574131f7"
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$

~~~~




After successful installation you can see all Kube Prometheus Stack pods created and running under kube-prometheus-stack namespace:
exemplo:
~~~~BASH
$ kubectl -n kube-prometheus-stack get pods
NAME                                                        READY   STATUS    RESTARTS   AGE
alertmanager-kube-prometheus-stack-alertmanager-0           2/2     Running   0          32d
kube-prometheus-stack-grafana-78457d9fc8-p48d9              3/3     Running   0          32d
kube-prometheus-stack-kube-state-metrics-5f6d6c64d5-xvcpw   1/1     Running   0          32d
kube-prometheus-stack-operator-6f4f8975fb-slt5c             1/1     Running   0          32d
kube-prometheus-stack-prometheus-node-exporter-jsfz6        1/1     Running   0          32d
kube-prometheus-stack-prometheus-node-exporter-qgxqp        1/1     Running   0          32d
kube-prometheus-stack-prometheus-node-exporter-xh2z7        1/1     Running   0          32d
prometheus-kube-prometheus-stack-prometheus-0               2/2     Running   0          32d
~~~~




kubectl -n kube-prometheus-stack get pods

~~~~BASH
fernando@debian10x64:~$ kubectl -n kube-prometheus-stack get pods
NAME                                                        READY   STATUS    RESTARTS        AGE
alertmanager-kube-prometheus-stack-alertmanager-0           2/2     Running   1 (2m27s ago)   2m31s
kube-prometheus-stack-grafana-76df987db5-5wldn              3/3     Running   0               2m35s
kube-prometheus-stack-kube-state-metrics-5d5f6ff4bc-8gg8h   1/1     Running   0               2m35s
kube-prometheus-stack-operator-8d4d67d7d-hzc8r              1/1     Running   0               2m35s
kube-prometheus-stack-prometheus-node-exporter-ckkxk        1/1     Running   0               2m35s
kube-prometheus-stack-prometheus-node-exporter-sj8bn        1/1     Running   0               2m35s
kube-prometheus-stack-prometheus-node-exporter-z9nc5        1/1     Running   0               2m35s
prometheus-kube-prometheus-stack-prometheus-0               2/2     Running   0               2m31s
fernando@debian10x64:~$ date
Sat 15 Apr 2023 08:32:02 PM -03
fernando@debian10x64:~$
~~~~


Let's login to Grafana now and see all metrics scraped by Prometheus displayed in beautiful Grafana dashboards.

    Get Grafana admin password:

1
kubectl get secret --namespace kube-prometheus-stack kube-prometheus-stack-grafana  -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

    To access Grafana dashboard you should forward your local port 8080 to the Grafana port 3030 with next command:

1
kubectl port-forward kube-prometheus-stack-grafana-78457d9fc8-p48d9 -n kube-prometheus-stack --address 0.0.0.0 8080:3000

    Open your browser and go to http://localhost:8080/ 

    . Then, login with username admin and above received password (default password: prom-operator).

    Inside Grafana, under Dashboards you can browse different preconfigured dashboards available for you out of the box.

As you can see, getting observability (logs and metrics) setup is pretty easy and straight forward with AWS EKS Blueprints Addons available for you. Now, let move into distributed tracing configuration.




fernando@debian10x64:~$ kubectl get secret --namespace kube-prometheus-stack kube-prometheus-stack-grafana  -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
prom-operator
fernando@debian10x64:~$

kubectl port-forward kube-prometheus-stack-grafana-76df987db5-5wldn -n kube-prometheus-stack --address 0.0.0.0 8080:3000

fernando@debian10x64:~$ kubectl port-forward kube-prometheus-stack-grafana-76df987db5-5wldn -n kube-prometheus-stack --address 0.0.0.0 8080:3000
Forwarding from 0.0.0.0:8080 -> 3000
Handling connection for 8080



- Acessando:
192.168.0.110:8080

~~~~bash

fernando@debian10x64:~$ curl -v 192.168.0.110:8080
* Expire in 0 ms for 6 (transfer 0x55934eccffb0)
*   Trying 192.168.0.110...
* TCP_NODELAY set
* Expire in 200 ms for 4 (transfer 0x55934eccffb0)
* Connected to 192.168.0.110 (192.168.0.110) port 8080 (#0)
> GET / HTTP/1.1
> Host: 192.168.0.110:8080
> User-Agent: curl/7.64.0
> Accept: */*
>
< HTTP/1.1 302 Found
< Cache-Control: no-cache
< Content-Type: text/html; charset=utf-8
< Expires: -1
< Location: /login
< Pragma: no-cache
< Set-Cookie: redirect_to=%2F; Path=/; HttpOnly; SameSite=Lax
< X-Content-Type-Options: nosniff
< X-Frame-Options: deny
< X-Xss-Protection: 1; mode=block
< Date: Sat, 15 Apr 2023 23:34:22 GMT
< Content-Length: 29
<
<a href="/login">Found</a>.

* Connection #0 to host 192.168.0.110 left intact
fernando@debian10x64:~$

~~~~



- Via navegador no Notebook-Avell local, OK também!
- Via navegador no Notebook-Avell local, OK também!
- Via navegador no Notebook-Avell local, OK também!
- Via navegador no Notebook-Avell local, OK também!



- Foram usados os addons de Prometheus(kube-prometheus-stack) para subir o Prometheus, Grafana e AlertManager:
https://catalog.workshops.aws/eks-blueprints-terraform/en-US/050-observability/2-metrics-kube-prometheus-stack#metrics-with-kube-prometheus-stack
https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack








kubectl get pods --selector app.kubernetes.io/name=grafana -A

fernando@debian10x64:~$ kubectl get pods --selector app.kubernetes.io/name=grafana -A
NAMESPACE               NAME                                             READY   STATUS    RESTARTS   AGE
kube-prometheus-stack   kube-prometheus-stack-grafana-76df987db5-5wldn   3/3     Running   0          25m
fernando@debian10x64:~$



kubectl get pods --selector app.kubernetes.io/name=grafana -n kube-prometheus-stack

fernando@debian10x64:~$ kubectl get pods --selector app.kubernetes.io/name=grafana -n kube-prometheus-stack
NAME                                             READY   STATUS    RESTARTS   AGE
kube-prometheus-stack-grafana-76df987db5-5wldn   3/3     Running   0          25m
fernando@debian10x64:~$




- Acesso ao grafana OK via Port-forward:

~~~~bash
kubectl get pods --selector app.kubernetes.io/name=grafana -n kube-prometheus-stack -o=name

fernando@debian10x64:~$ kubectl get pods --selector app.kubernetes.io/name=grafana -n kube-prometheus-stack -o=name
pod/kube-prometheus-stack-grafana-76df987db5-5wldn
fernando@debian10x64:~$

kubectl port-forward $(kubectl get pods --selector app.kubernetes.io/name=grafana -n kube-prometheus-stack -o=name) -n kube-prometheus-stack --address 0.0.0.0 8080:3000
~~~~


- Erro ao tentar acessar o Prometheus via Port-forward:

~~~~bash
kubectl get pods --selector app.kubernetes.io/name=prometheus -n kube-prometheus-stack -o=name

kubectl port-forward $(kubectl get pods --selector app.kubernetes.io/name=grafana -n kube-prometheus-stack -o=name) -n kube-prometheus-stack --address 0.0.0.0 9090:9090


fernando@debian10x64:~$ kubectl port-forward $(kubectl get pods --selector app.kubernetes.io/name=grafana -n kube-prometheus-stack -o=name) -n kub                                        e-prometheus-stack --address 0.0.0.0 9090:9090
Forwarding from 0.0.0.0:9090 -> 9090
Handling connection for 9090
E0415 21:00:15.583457    7565 portforward.go:406] an error occurred forwarding 9090 -> 9090: error forwarding port 9090 to pod d8643b07130cd250e6b20a3efb270e49dd548763365d2dd375f535755add34a6, uid : exit status 1: 2023/04/16 00:00:15 socat[25647] E connect(5, AF=2 127.0.0.1:9090, 16): Connection refused
E0415 21:00:15.585253    7565 portforward.go:234] lost connection to pod
fernando@debian10x64:~$
~~~~



- Container do Prometheus tem esses argumentos

Arguments

    --web.console.templates=/etc/prometheus/consoles
    --web.console.libraries=/etc/prometheus/console_libraries
    --storage.tsdb.retention.time=10d
    --config.file=/etc/prometheus/config_out/prometheus.env.yaml
    --storage.tsdb.path=/prometheus
    --web.enable-lifecycle
    --web.external-url=http://kube-prometheus-stack-prometheus.kube-prometheus-stack:9090
    --web.route-prefix=/
    --storage.tsdb.wal-compression
    --web.config.file=/etc/prometheus/web_config/web-config.yaml



e como deve estar a variável web.external-url?

A variável web.external-url é usada para definir a URL externa do Prometheus, que é usada para construir URLs absolutas para consultas e alertas. Se você deseja acessar o Prometheus de um navegador ou ferramenta externa, é importante definir essa variável corretamente.

Por padrão, a variável web.external-url é comentada no arquivo de configuração prometheus.yml do kube-prometheus-stack. Para definir essa variável, você deve descomentá-la e atribuir a URL externa do seu Prometheus.

Por exemplo, se você deseja definir a URL externa como http://prometheus.example.com, sua configuração deve incluir a seguinte linha:

kotlin

web:
  external-url: http://prometheus.example.com

Você pode adicionar esta linha no arquivo prometheus.yml ou definir a variável como um argumento de linha de comando no momento da inicialização do Prometheus. Por exemplo, se estiver usando o docker run, você pode definir a variável usando o seguinte comando:

bash

docker run -p 9090:9090 -v /path/to/prometheus.yml:/etc/prometheus/prometheus.yml -e "web.external-url=http://prometheus.example.com" prom/prometheus

Lembre-se de substituir http://prometheus.example.com pela URL externa correta do seu Prometheus.






Quando o argumento --web.external-url=http://kube-prometheus-stack-prometheus.kube-prometheus-stack:9090 é passado dessa maneira, isso significa que a variável web.external-url está sendo definida com o valor http://kube-prometheus-stack-prometheus.kube-prometheus-stack:9090.

Isso indica que a URL externa do Prometheus é definida como http://kube-prometheus-stack-prometheus.kube-prometheus-stack:9090. Esse valor deve ser substituído pelo endereço correto do seu servidor Prometheus.

Note que a URL http://kube-prometheus-stack-prometheus.kube-prometheus-stack:9090 inclui o nome do host do Pod do Prometheus (kube-prometheus-stack-prometheus) e o nome do namespace (kube-prometheus-stack), seguido da porta (9090). Isso é usado para acessar o serviço do Prometheus de dentro do cluster do Kubernetes.

Se você quiser acessar o Prometheus de fora do cluster, é necessário definir um serviço do tipo LoadBalancer ou NodePort para o serviço do Prometheus e, em seguida, usar o endereço IP ou nome de host externo do serviço em sua variável web.external-url.






kubectl exec -ti $(kubectl get pods --selector app.kubernetes.io/name=grafana -n kube-prometheus-stack -o=name) -n kube-prometheus-stack -- sh



    - --web.external-url=http://kube-prometheus-stack-prometheus.kube-prometheus-stack:9090



    - --web.external-url:
     - http://kube-prometheus-stack-prometheus.kube-prometheus-stack:9090
     - http://192.168.0.110:9090

fernando@debian10x64:~$ ^C
fernando@debian10x64:~$ kubectl edit pod/prometheus-kube-prometheus-stack-prometheus-0 -n kube-prometheus-stack
Edit cancelled, no changes made.
fernando@debian10x64:~$ kubectl edit pod/prometheus-kube-prometheus-stack-prometheus-0 -n kube-prometheus-stack
error: pods "prometheus-kube-prometheus-stack-prometheus-0" is invalid
A copy of your changes has been stored to "/tmp/kubectl-edit-1507445489.yaml"
error: Edit cancelled, no valid changes were saved.
fernando@debian10x64:~$





- EFETUANDO DESTROY
terraform destroy -target=module.kubernetes_addons -auto-approve
terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve



----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

# PENDENTE

## Material de apoio:
- Values de referencia:
/home/fernando/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint/bkp-antes/values.yaml

- Chart do Prometheus
https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus

## Continuar em:

- Expor Prometheus ao mundo, verificar como fazer para expor o Prometheus que está no AWS EKS.
expondo via service:
https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/user-guides/exposing-prometheus-and-alertmanager.md
Necessário ajustar o cluster EKS, para que tenha Nodes publicos numa Subnet Publica, para ter um External IP.
Avaliar se criar Cluster EKS só com o Node-group de Subnet Publica ou expor via Ingress(verificar como).

Expor o Prometheus via Ingress ao invés de Port-Forward

- Grafana OK.

- Prometheus ÑOK
erros no Port-forward
E0415 21:00:15.583457    7565 portforward.go:406] an error occurred forwarding 9090 -> 9090: error forwarding port 9090 to pod 

- Ver como passar um value para o Prometheus utilizar um web.external-url diferente?
https://aws-ia.github.io/terraform-aws-eks-blueprints/add-ons/prometheus/

- Ver como o kube-prometheus-stack pode ser configurado para expor uma URL diferente desta:
    --web.external-url=http://kube-prometheus-stack-prometheus.kube-prometheus-stack:9090
https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

- Persistencia, ver melhor maneira e erros ocorridos.
- Quando utilizando Persistence, os Pods do Prometheus-Server e do AlertManager não sobem.
Pode ser devido o GP2 e o PVC que eles tentam utilizar.
Tentar aplicar solução, criando o PVC tbm:
https://stackoverflow.com/questions/47235014/why-prometheus-pod-pending-after-setup-it-by-helm-in-kubernetes-cluster-on-ranch
<https://stackoverflow.com/questions/47235014/why-prometheus-pod-pending-after-setup-it-by-helm-in-kubernetes-cluster-on-ranch>
https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
<https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack>

- Helm via Terraform, verificar como fazer o Terraform aplicar o chart do Prometheus.
usar o values personalizado.













# dia 16/04/2023

terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks_blueprints -auto-approve
terraform apply -target=module.kubernetes_addons -auto-approve
terraform apply -auto-approve

configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-0b887b33857e57ce9"




https://github.com/aws-ia/terraform-aws-eks-blueprints/tree/main/modules/kubernetes-addons/kube-prometheus-stack
kube-prometheus-stack Helm Chart
Introduction

kube-prometheus-stack is a a collection of Kubernetes manifests, Grafana dashboards, and Prometheus rules combined with documentation and scripts to provide easy to operate end-to-end Kubernetes cluster monitoring with Prometheus using the Prometheus Operator.

The default values.yaml file in this add-on has disabled the components that are unreachable in EKS environments, and an EBS Volume for Persistent Storage.








kube_prometheus_stack_helm_config



- Exemplo

Enable Prometheus with custom values.yaml

  #---------------------------------------
  # Prometheus Server integration with Amazon Prometheus
  #---------------------------------------
  # Amazon Prometheus Configuration to integrate with Prometheus Server Add-on
  enable_amazon_prometheus = true
  amazon_prometheus_workspace_endpoint = "<Enter Amazon Workspace Endpoint>" # eg.,  module.eks-blueprints.amazon_prometheus_workspace_endpoint

  enable_prometheus = true
  # Optional Map value
  prometheus_helm_config = {
    name       = "prometheus"                                         # (Required) Release name.
    repository = "https://prometheus-community.github.io/helm-charts" # (Optional) Repository URL where to locate the requested chart.
    chart      = "prometheus"                                         # (Required) Chart name to be installed.
    version    = "15.3.0"                                             # (Optional) Specify the exact chart version to install. If this is not specified, it defaults to the version set within default_helm_config: https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/modules/kubernetes-addons/prometheus/locals.tf
    namespace  = "prometheus"                                         # (Optional) The namespace to install the release into.
    values = [templatefile("${path.module}/prometheus-values.yaml", {
      operating_system = "linux"
    })]
  }






- Editando

Enable Prometheus with custom values.yaml

  kube_prometheus_stack_helm_config = {
    name       = "kube-prometheus-stack"                                         # (Required) Release name.
    repository = "https://prometheus-community.github.io/helm-charts" # (Optional) Repository URL where to locate the requested chart.
    chart      = "kube-prometheus-stack"                                         # (Required) Chart name to be installed.
    namespace  = "kube-prometheus-stack"                                        # (Optional) The namespace to install the release into.
    values = [templatefile("${path.module}/values-stack.yaml", {
      operating_system = "linux"
    })]
  }










# FONTE
https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml
<https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml>

## Deploy a Prometheus instance
##
prometheus:
  enabled: true
  ## Configuration for Prometheus service
  ##
  service:
    annotations: {}
    labels: {}
    clusterIP: ""



- Editado o main.tf:

~~~~h

module "kubernetes_addons" {
source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.21.0/modules/kubernetes-addons"

  eks_cluster_id                = module.eks_blueprints.eks_cluster_id

  enable_aws_load_balancer_controller  = true
  enable_amazon_eks_aws_ebs_csi_driver = true
  enable_metrics_server                = true
  enable_kube_prometheus_stack         = true # <-- Add this line

  kube_prometheus_stack_helm_config = {
    name       = "kube-prometheus-stack"                                         # (Required) Release name.
    #repository = "https://prometheus-community.github.io/helm-charts" # (Optional) Repository URL where to locate the requested chart.
    chart      = "kube-prometheus-stack"                                         # (Required) Chart name to be installed.
    namespace  = "kube-prometheus-stack"                                        # (Optional) The namespace to install the release into.
    values = [templatefile("${path.module}/values-stack.yaml", {
      operating_system = "linux"
    })]
  }

  depends_on = [
    module.eks_blueprints
  ]

}
~~~~




- Efetuando plan e apply:

terraform apply -auto-approve

~~~~bash

Terraform will perform the following actions:

  # module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0] will be updated in-place
  ~ resource "helm_release" "addon" {
        id                         = "kube-prometheus-stack"
        name                       = "kube-prometheus-stack"
      ~ values                     = [
          - <<-EOT
                # Create default rules for monitoring the cluster
                # Disable rules for unreachable components
                defaultRules:
                  create: true
                  rules:
                    etcd: false
                    kubeScheduler: false

                # Disable component scraping for the kube controller manager, etcd, and kube-scheduler
                # These components are not reachable on EKS
                kubeControllerManager:
                  enabled: false
                kubeEtcd:
                  enabled: false
                kubeScheduler:
                  enabled: false

                prometheus:
                  prometheusSpec:
                    # Prometheus StorageSpec for persistent data on AWS EBS
                    # ref: https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/user-guides/storage.md
                    storageSpec:
                     volumeClaimTemplate:
                       spec:
                         storageClassName: gp2
                         accessModes: ["ReadWriteOnce"]
                         resources:
                           requests:
                             storage: 20Gi
            EOT,
          + <<-EOT
                defaultRules:
                  create: true
                  rules:
                    etcd: false
                    kubeScheduler: false
                kubeControllerManager:
                  enabled: false
                kubeEtcd:
                  enabled: false
                kubeScheduler:
                  enabled: false
                prometheus:
                  prometheusSpec:
                    storageSpec:
                      volumeClaimTemplate:
                        spec:
                          accessModes:
                          - ReadWriteOnce
                          resources:
                            requests:
                              storage: 20Gi
                          storageClassName: gp2
                  enabled: true
                  ## Configuration for Prometheus service
                  ##
                  service:
                    annotations: {}
                    labels: {}
                    clusterIP: ""
                    port: 9090
                    ## To be used with a proxy extraContainer port
                    targetPort: 9090
                    ## List of IP addresses at which the Prometheus server service is available
                    ## Ref: https://kubernetes.io/docs/user-guide/services/#external-ips
                    ##
                    externalIPs: []
                    ## Port to expose on each node
                    ## Only used if service.type is 'NodePort'
                    ##
                    nodePort: 30090
                    type: NodePort
            EOT,
        ]
        # (28 unchanged attributes hidden)

        # (1 unchanged block hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Modifying... [id=kube-prometheus-stack]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 10s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 20s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 30s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 40s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 50s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 1m0s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 1m10s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 1m20s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 1m30s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 1m40s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 1m50s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 2m0s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 2m10s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 2m20s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 2m30s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 2m40s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 2m50s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 3m0s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 3m10s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 3m20s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 3m30s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 3m40s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 3m50s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 4m0s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 4m10s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 4m20s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 4m30s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 4m40s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 4m50s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Still modifying... [id=kube-prometheus-stack, 5m0s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Modifications complete after 5m1s [id=kube-prometheus-stack]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-0b887b33857e57ce9"
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$

~~~~








- Verificando o Service, virou NodePort e com a port desejada.
- Nodes estão com ips publicos.
- Primeiro teste de acesso ao Prometheus via, sem sucesso.
- Liberado tráfego para todas origens na SG da EC2, acesso ficou OK.

~~~~bash

SERVICE NodePort OK

fernando@debian10x64:~$ kubectl get svc -A
NAMESPACE               NAME                                             TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                        AGE
default                 kubernetes                                       ClusterIP   172.20.0.1       <none>        443/TCP                        82m
kube-prometheus-stack   alertmanager-operated                            ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP     70m
kube-prometheus-stack   kube-prometheus-stack-alertmanager               ClusterIP   172.20.64.90     <none>        9093/TCP                       70m
kube-prometheus-stack   kube-prometheus-stack-grafana                    ClusterIP   172.20.217.105   <none>        80/TCP                         70m
kube-prometheus-stack   kube-prometheus-stack-kube-state-metrics         ClusterIP   172.20.78.3      <none>        8080/TCP                       70m
kube-prometheus-stack   kube-prometheus-stack-operator                   ClusterIP   172.20.4.0       <none>        443/TCP                        70m
kube-prometheus-stack   kube-prometheus-stack-prometheus                 NodePort    172.20.207.228   <none>        9090:30090/TCP                 70m
kube-prometheus-stack   kube-prometheus-stack-prometheus-node-exporter   ClusterIP   172.20.52.51     <none>        9100/TCP                       70m
kube-prometheus-stack   prometheus-operated                              ClusterIP   None             <none>        9090/TCP                       70m
kube-system             aws-load-balancer-webhook-service                ClusterIP   172.20.0.233     <none>        443/TCP                        72m
kube-system             kube-dns                                         ClusterIP   172.20.0.10      <none>        53/UDP,53/TCP                  82m
kube-system             kube-prometheus-stack-coredns                    ClusterIP   None             <none>        9153/TCP                       70m
kube-system             kube-prometheus-stack-kube-proxy                 ClusterIP   None             <none>        10249/TCP                      70m
kube-system             kube-prometheus-stack-kubelet                    ClusterIP   None             <none>        10250/TCP,10255/TCP,4194/TCP   70m
kube-system             metrics-server                                   ClusterIP   172.20.60.69     <none>        443/TCP                        72m
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$ kubectl get nodes -o wide
NAME                         STATUS   ROLES    AGE   VERSION                INTERNAL-IP   EXTERNAL-IP     OS-IMAGE         KERNEL-VERSION                 CONTAINER-RUNTIME
ip-10-0-0-226.ec2.internal   Ready    <none>   77m   v1.23.17-eks-a59e1f0   10.0.0.226    3.235.247.118   Amazon Linux 2   5.4.238-148.346.amzn2.x86_64   docker://20.10.17
ip-10-0-1-218.ec2.internal   Ready    <none>   77m   v1.23.17-eks-a59e1f0   10.0.1.218    34.201.72.159   Amazon Linux 2   5.4.238-148.346.amzn2.x86_64   docker://20.10.17
ip-10-0-2-220.ec2.internal   Ready    <none>   77m   v1.23.17-eks-a59e1f0   10.0.2.220    3.80.31.184     Amazon Linux 2   5.4.238-148.346.amzn2.x86_64   docker://20.10.17


TESTE ÑOK

fernando@debian10x64:~$ curl -v 3.235.247.118:30090 | head
* Expire in 0 ms for 6 (transfer 0x560fbe412fb0)
*   Trying 3.235.247.118...
* TCP_NODELAY set
* Expire in 200 ms for 4 (transfer 0x560fbe412fb0)
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:31 --:--:--     0* connect to 3.235.247.118 port 30090 failed: Connection timed out
* Failed to connect to 3.235.247.118 port 30090: Connection timed out
* Closing connection 0
curl: (7) Failed to connect to 3.235.247.118 port 30090: Connection timed out
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$

TESTE OK - após liberada SG da EC2

fernando@debian10x64:~$ curl -v 3.235.247.118:30090 | head -N 58
head: invalid option -- 'N'
Try 'head --help' for more information.
* Expire in 0 ms for 6 (transfer 0x5648438d4fb0)
*   Trying 3.235.247.118...
* TCP_NODELAY set
* Expire in 200 ms for 4 (transfer 0x5648438d4fb0)
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0* Connected to 3.235.247.118 (3.235.247.118) port 30090 (#0)
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0> GET / HTTP/1.1
> Host: 3.235.247.118:30090
> User-Agent: curl/7.64.0
> Accept: */*
>
< HTTP/1.1 302 Found
< Content-Type: text/html; charset=utf-8
< Location: /graph
< Date: Sun, 16 Apr 2023 23:38:31 GMT
< Content-Length: 29
<
{ [29 bytes data]
100    29  100    29    0     0     99      0 --:--:-- --:--:-- --:--:--    98
* Connection #0 to host 3.235.247.118 left intact
(23) Failed writing body
fernando@debian10x64:~$

~~~~





- RESUMO

- Verifica a sintaxe de como editar o Helm Config:
https://aws-ia.github.io/terraform-aws-eks-blueprints/add-ons/prometheus/

- Verificados os valores padrão e os argumentos aceitos pelo módulo "Kubernetes Addons":
https://github.com/aws-ia/terraform-aws-eks-blueprints/tree/main/modules/kubernetes-addons#input_kube_prometheus_stack_helm_config
verificado que precisa usar:
kube_prometheus_stack_helm_config 	Community kube-prometheus-stack Helm Chart config 	any

-Verificados os values utilizados pelo stack padrão:
https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/modules/kubernetes-addons/kube-prometheus-stack/values.yaml

- Verificados os values de referencia, para poder criar um mais completo/personalizado:
https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml

- Adicionado o values personalizado no módulo "Kubernetes Addons":
~~~~h
templatefile("${path.module}/values-stack.yaml
~~~~







Como fazer o Terraform editar a SG que é anexada a EC2 dos node groups que são criados via módulo eks_blueprints ?

module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.21.0"






- Efetuando destroy

terraform destroy -target=module.kubernetes_addons -auto-approve
terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve





## PENDENTE
- Ajustar SG das EC2 do node-group via manifesto do EKS-BLUEPRINT. Liberar porta 30090, por exemplo, para que o Prometheus fique acessivel de fora.
- Criar KB, sobre como ajustar o Helm do "kube-prometheus-stack" via EKS-BLUEPRINT.







# Dia 21/04/2023

terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks_blueprints -auto-approve
terraform apply -target=module.kubernetes_addons -auto-approve
terraform apply -auto-approve

- Ajustar SG das EC2 do node-group via manifesto do EKS-BLUEPRINT. Liberar porta 30090, por exemplo, para que o Prometheus fique acessivel de fora.

21:12h - subindo EKS

configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-06ce67bba86f683c1"



- Criado manifesto da sg
/home/fernando/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint/security-group.tf

- Adicionar o seguinte no main.tf:

~~~~t
  # IDs dos Security Groups a serem associados aos "managed_node_groups"
  managed_node_groups_launch_template_security_group_ids = [aws_security_group.sg.id]
~~~~


- ERRO

~~~~bash


fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ terraform plan
╷
│ Error: Unsupported argument
│
│   on main.tf line 95, in module "eks_blueprints":
│   95:   managed_node_groups_launch_template_security_group_ids = [aws_security_group.sg.id]
│
│ An argument named "managed_node_groups_launch_template_security_group_ids" is not expected here.
╵
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$

~~~~







- Efetuando teste, adicionando o trecho sobre "scaling_config" no "managed_node_groups" do Blueprint:

~~~~t

  # EKS MANAGED NODE GROUPS
  managed_node_groups = {
#    T3A_NODE = {
#      node_group_name = local.node_group_name
#      instance_types  = ["t3a.medium"]
#      subnet_ids      = module.vpc.private_subnets
#      #subnet_ids      = module.vpc.public_subnets
#    }
    T3A_NODE2 = {
      node_group_name = "teste2"
      instance_types  = ["t3a.medium"]
      subnet_ids      = module.vpc.public_subnets

      scaling_config = {
        # IDs dos Security Groups a serem associados ao grupo de nós
        additional_security_group_ids = [aws_security_group.sg.id]
      }

    }
  }

~~~~



- Efetuando validate

~~~~bash

fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ terraform validate
Success! The configuration is valid.

~~~~


- Nada aconteceu, seguiu igual o Cluster.
- Nada aconteceu, seguiu igual o Cluster.
- Nada aconteceu, seguiu igual o Cluster.
- Nada aconteceu, seguiu igual o Cluster.
- Nada aconteceu, seguiu igual o Cluster.










node_security_group_id

fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ terraform plan
╷
│ Error: Unsupported argument
│
│   on main.tf line 94, in module "eks_blueprints":
│   94:   node_security_group_id = aws_security_group.sg.id
│
│ An argument named "node_security_group_id" is not expected here.
╵
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$









~~~~t
module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.21.0"

  # Configurações do módulo

  node_security_group_additional_rules = [
    # Exemplo de regra de ingresso
    {
      type        = "ingress"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Exemplo de regra de egresso
    {
      type        = "egress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

~~~~









  create_node_security_group           = var.create_node_security_group
  node_security_group_name             = var.node_security_group_name
  node_security_group_use_name_prefix  = var.node_security_group_use_name_prefix
  node_security_group_description      = var.node_security_group_description
  node_security_group_additional_rules = var.node_security_group_additional_rules
  node_security_group_tags             = var.node_security_group_tags



  create_node_security_group           
  node_security_group_name             
  node_security_group_use_name_prefix  
  node_security_group_description      
  node_security_group_additional_rules 
  node_security_group_tags            



Claro! Aqui está um exemplo de como você pode configurar os parâmetros adicionais do módulo "aws_eks" junto com o uso do argumento node_security_group_additional_rules:

~~~~t

module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.21.0"

  # Configurações do módulo
  create_node_security_group           = true
  node_security_group_name             = "my-eks-node-security-group"
  node_security_group_use_name_prefix  = false
  node_security_group_description      = "My EKS Node Security Group"
  node_security_group_additional_rules = [
    # Exemplo de regra de ingresso
    {
      type        = "ingress"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Exemplo de regra de egresso
    {
      type        = "egress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  node_security_group_tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
~~~~


Neste exemplo, os parâmetros create_node_security_group, node_security_group_name, node_security_group_use_name_prefix, node_security_group_description e node_security_group_tags são configurados junto com o uso do argumento node_security_group_additional_rules para adicionar regras de segurança adicionais aos grupos de nós gerenciados do cluster EKS. Certifique-se de modificar os valores de acordo com suas necessidades específicas.










- Erro

~~~~bash
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["egress_nodes_kubelet"]: Refreshing state... [id=sgrule-3081823999]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["egress_nodes_443"]: Refreshing state... [id=sgrule-3935461898]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["ingress_nodes_443"]: Refreshing state... [id=sgrule-695323498]
╷
│ Error: Error in function call
│
│   on .terraform/modules/eks_blueprints.aws_eks/node_groups.tf line 171, in resource "aws_security_group_rule" "node":
│  171:   for_each = { for k, v in merge(local.node_security_group_rules, var.node_security_group_additional_rules) : k => v if local.create_node_sg }
│     ├────────────────
│     │ local.node_security_group_rules is object with 10 attributes
│     │ var.node_security_group_additional_rules is tuple with 2 elements
│
│ Call to function "merge" failed: arguments must be maps or objects, got "tuple".
╵
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$
~~~~







Peço desculpas pelo erro. Você está correto, o argumento node_security_group_additional_rules no módulo aws_eks espera um objeto ou mapa, mas estamos fornecendo uma lista de regras como um exemplo anterior.

Aqui está uma correção para o exemplo anterior, para usar um objeto em vez de uma lista de regras:

~~~~t

module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.21.0"

  # Configurações do módulo
  create_node_security_group           = true
  node_security_group_name             = "my-eks-node-security-group"
  node_security_group_use_name_prefix  = false
  node_security_group_description      = "My EKS Node Security Group"
  node_security_group_additional_rules = {
    # Exemplo de regra de ingresso
    ingress_example = {
      type        = "ingress"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Exemplo de regra de egresso
    egress_example = {
      type        = "egress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  node_security_group_tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
~~~~

Agora, estamos fornecendo um objeto para o argumento node_security_group_additional_rules, com chaves e valores representando as regras de segurança adicionais desejadas. Isso deve corrigir o erro e permitir que o código Terraform seja executado corretamente. Novamente, certifique-se de ajustar os valores de acordo com suas necessidades específicas.












- ORIGINAL

eks-lab-node	sg-05419262c58b82268	eks-lab-node-20230422000758685700000002	vpc-06ce67bba86f683c1
	EKS node shared security group

Inbound rules (4)

	Name
	Security group rule ID
	IP version
	Type
	Protocol
	Port range
	Source
	Description
	–	sgr-0f789239462b2de67	–	Custom TCP	TCP	10250	sg-02e6be5a34ccda5f7 / eks-lab-cluster-20230422000758683400000001	Cluster API to node kubelets
	–	sgr-087447b86b77898da	–	DNS (UDP)	UDP	53	sg-05419262c58b82268 / eks-lab-node-20230422000758685700000002	Node to node CoreDNS
	–	sgr-0178d95e9f8a25a6f	–	HTTPS	TCP	443	sg-02e6be5a34ccda5f7 / eks-lab-cluster-20230422000758683400000001	Cluster API to node groups
	–	sgr-0e55fc2d0e2f760a5	–	DNS (TCP)	TCP	53	sg-05419262c58b82268 / eks-lab-node-20230422000758685700000002	Node to node CoreDNS









- erro


module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_cluster_443"]: Creation complete after 8s [id=sgrule-4196098811]
╷
│ Error: [WARN] A duplicate Security Group rule was found on (sg-0f670a1c8e36994c1). This may be
│ a side effect of a now-fixed Terraform issue causing two security groups with
│ identical attributes but different source_security_group_ids to overwrite each
│ other in the state. See https://github.com/hashicorp/terraform/pull/2376 for more
│ information and instructions for recovery. Error: InvalidPermission.Duplicate: the specified rule "peer: 0.0.0.0/0, TCP, from port: 443, to port: 443, ALLOW" already exists
│       status code: 400, request id: 03b1e2e0-900f-4e14-931f-7165ae3673f1
│
│   with module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_example"],
│   on .terraform/modules/eks_blueprints.aws_eks/node_groups.tf line 170, in resource "aws_security_group_rule" "node":
│  170: resource "aws_security_group_rule" "node" {
│
╵
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$



- Ajustando

      from_port   = 30093
      to_port     = 30093




~~~~bash

fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ terraform apply -auto-approve
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_self_coredns_tcp"] (deposed object 3b6a7f95): Refreshing state... [id=sgrule-3591147875]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_cluster_443"] (deposed object c23413c1): Refreshing state... [id=sgrule-1487053307]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["ingress_nodes_443"] (deposed object 508207ad): Refreshing state... [id=sgrule-695323498]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_self_coredns_udp"] (deposed object b3c7ec09): Refreshing state... [id=sgrule-3111923594]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_ntp_udp"] (deposed object b526a1b7): Refreshing state... [id=sgrule-2442639657]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_https"] (deposed object 0a4c5768): Refreshing state... [id=sgrule-819437882]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["egress_nodes_443"] (deposed object 0a1b86ad): Refreshing state... [id=sgrule-3935461898]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_self_coredns_udp"] (deposed object c192202e): Refreshing state... [id=sgrule-1483412229]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_cluster_443"] (deposed object c5b6d455): Refreshing state... [id=sgrule-4177801947]
module.eks_blueprints.module.aws_eks.aws_security_group.node[0] (deposed object f555d40c): Refreshing state... [id=sg-05419262c58b82268]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["egress_nodes_kubelet"] (deposed object fdd872c2): Refreshing state... [id=sgrule-3081823999]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_ntp_tcp"] (deposed object f10922f1): Refreshing state... [id=sgrule-4010384420]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_self_coredns_tcp"] (deposed object 662c48b5): Refreshing state... [id=sgrule-488868965]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_cluster_kubelet"] (deposed object 27150a2d): Refreshing state... [id=sgrule-3147465503]
module.vpc.aws_vpc.this[0]: Refreshing state... [id=vpc-06ce67bba86f683c1]
aws_security_group.sg: Refreshing state... [id=sg-0acd6eab376a40bcb]
module.vpc.aws_eip.nat[0]: Refreshing state... [id=eipalloc-060cc671fe2203562]
module.eks_blueprints.module.aws_eks.aws_iam_role.this[0]: Refreshing state... [id=eks-lab-cluster-role]
module.eks_blueprints.module.kms[0].aws_kms_key.this: Refreshing state... [id=9491e753-a277-4773-896f-48be5e7ed2a6]
module.eks_blueprints.module.aws_eks.aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"]: Refreshing state... [id=eks-lab-cluster-role-20230422000800428900000004]
module.eks_blueprints.module.aws_eks.aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]: Refreshing state... [id=eks-lab-cluster-role-20230422000800207000000003]
module.eks_blueprints.module.kms[0].aws_kms_alias.this: Refreshing state... [id=alias/eks-lab]
module.vpc.aws_default_route_table.default[0]: Refreshing state... [id=rtb-02a490bd75e3d8b6a]
module.vpc.aws_default_network_acl.this[0]: Refreshing state... [id=acl-01c3d18ad23948cb3]
module.vpc.aws_subnet.private[1]: Refreshing state... [id=subnet-0bd033c7612c25e4a]
module.eks_blueprints.module.aws_eks.aws_security_group.node[0]: Refreshing state... [id=sg-0f670a1c8e36994c1]
module.vpc.aws_subnet.private[0]: Refreshing state... [id=subnet-07366daa05b22ae37]
module.vpc.aws_default_security_group.this[0]: Refreshing state... [id=sg-0661a6303e0e91257]
module.vpc.aws_internet_gateway.this[0]: Refreshing state... [id=igw-099098ea7db0bc5ef]
module.vpc.aws_route_table.private[0]: Refreshing state... [id=rtb-0191c122852489100]
module.vpc.aws_subnet.private[2]: Refreshing state... [id=subnet-05fef12bb2f126fdf]
module.eks_blueprints.module.aws_eks.aws_security_group.cluster[0]: Refreshing state... [id=sg-02e6be5a34ccda5f7]
module.vpc.aws_subnet.public[1]: Refreshing state... [id=subnet-0c4a8262511329c3f]
module.vpc.aws_route_table.public[0]: Refreshing state... [id=rtb-0635faa6fa1be3306]
module.vpc.aws_subnet.public[0]: Refreshing state... [id=subnet-09d514a08bac0e589]
module.vpc.aws_subnet.public[2]: Refreshing state... [id=subnet-0d03d2d63e662d1b1]
module.vpc.aws_route_table_association.private[2]: Refreshing state... [id=rtbassoc-0f5b1c96737a73fa4]
module.vpc.aws_route_table_association.private[1]: Refreshing state... [id=rtbassoc-035687ec79e663950]
module.vpc.aws_route_table_association.private[0]: Refreshing state... [id=rtbassoc-02d1e84cc4844a7a0]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_self_coredns_udp"]: Refreshing state... [id=sgrule-1584882114]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_cluster_443"]: Refreshing state... [id=sgrule-4196098811]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_cluster_443"]: Refreshing state... [id=sgrule-4188441368]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_cluster_kubelet"]: Refreshing state... [id=sgrule-2312952067]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_ntp_tcp"]: Refreshing state... [id=sgrule-666015455]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_ntp_udp"]: Refreshing state... [id=sgrule-1496101842]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_example"]: Refreshing state... [id=sgrule-3038877186]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_self_coredns_tcp"]: Refreshing state... [id=sgrule-3428936300]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_self_coredns_udp"]: Refreshing state... [id=sgrule-1748945283]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_https"]: Refreshing state... [id=sgrule-4167871425]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_self_coredns_tcp"]: Refreshing state... [id=sgrule-3490767780]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["egress_nodes_443"]: Refreshing state... [id=sgrule-3848468000]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["egress_nodes_kubelet"]: Refreshing state... [id=sgrule-3091231445]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["ingress_nodes_443"]: Refreshing state... [id=sgrule-646012736]
module.vpc.aws_route.public_internet_gateway[0]: Refreshing state... [id=r-rtb-0635faa6fa1be33061080289494]
module.vpc.aws_nat_gateway.this[0]: Refreshing state... [id=nat-003939fe45a190922]
module.vpc.aws_route_table_association.public[1]: Refreshing state... [id=rtbassoc-0e0e1c64aefb50117]
module.vpc.aws_route_table_association.public[2]: Refreshing state... [id=rtbassoc-00e159b3058b7475a]
module.vpc.aws_route_table_association.public[0]: Refreshing state... [id=rtbassoc-0acd4745fa4cad650]
module.vpc.aws_route.private_nat_gateway[0]: Refreshing state... [id=r-rtb-0191c1228524891001080289494]
module.eks_blueprints.module.aws_eks.aws_eks_cluster.this[0]: Refreshing state... [id=eks-lab]
module.eks_blueprints.module.aws_eks.aws_ec2_tag.cluster_primary_security_group["GithubRepo"]: Refreshing state... [id=sg-0f552d7b44716d1ed,GithubRepo]
module.eks_blueprints.module.aws_eks.aws_ec2_tag.cluster_primary_security_group["Blueprint"]: Refreshing state... [id=sg-0f552d7b44716d1ed,Blueprint]
module.eks_blueprints.module.aws_eks.aws_iam_openid_connect_provider.oidc_provider[0]: Refreshing state... [id=arn:aws:iam::261106957109:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/B5287FFBCE112FDB3C90BCED28AE250F]
module.eks_blueprints.kubernetes_config_map.aws_auth[0]: Refreshing state... [id=kube-system/aws-auth]
module.eks_blueprints.module.aws_eks_teams[0].aws_iam_policy.platform_team_eks_access[0]: Refreshing state... [id=arn:aws:iam::261106957109:policy/eks-lab-PlatformTeamEKSAccess]
module.eks_blueprints.module.aws_eks_teams[0].aws_iam_role.platform_team["admin"]: Refreshing state... [id=eks-lab-admin-access]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_NODE2"].aws_iam_role.managed_ng[0]: Refreshing state... [id=eks-lab-teste2]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_NODE2"].aws_iam_role_policy_attachment.managed_ng["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"]: Refreshing state... [id=eks-lab-teste2-20230422001908390400000005]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_NODE2"].aws_iam_role_policy_attachment.managed_ng["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]: Refreshing state... [id=eks-lab-teste2-20230422001908422900000006]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_NODE2"].aws_iam_role_policy_attachment.managed_ng["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]: Refreshing state... [id=eks-lab-teste2-20230422001908600800000007]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_NODE2"].aws_iam_instance_profile.managed_ng[0]: Refreshing state... [id=eks-lab-teste2]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_NODE2"].aws_iam_role_policy_attachment.managed_ng["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]: Refreshing state... [id=eks-lab-teste2-20230422001908668000000008]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_NODE2"].aws_eks_node_group.managed_ng: Refreshing state... [id=eks-lab:teste2-20230422001909567200000009]
kubectl_manifest.rbac: Refreshing state... [id=/apis/rbac.authorization.k8s.io/v1/clusterroles/eks-console-dashboard-full-access-clusterrole]
module.kubernetes_addons.time_sleep.dataplane: Refreshing state... [id=2023-04-22T00:26:11Z]
module.kubernetes_addons.module.kube_prometheus_stack[0].kubernetes_namespace_v1.prometheus: Refreshing state... [id=kube-prometheus-stack]
module.kubernetes_addons.module.metrics_server[0].module.helm_addon.helm_release.addon[0]: Refreshing state... [id=metrics-server]
module.kubernetes_addons.module.aws_load_balancer_controller[0].module.helm_addon.module.irsa[0].kubernetes_service_account_v1.irsa[0]: Refreshing state... [id=kube-system/aws-load-balancer-controller-sa]
module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0]: Refreshing state... [id=kube-prometheus-stack]
module.kubernetes_addons.module.aws_load_balancer_controller[0].module.helm_addon.helm_release.addon[0]: Refreshing state... [id=aws-load-balancer-controller]

Note: Objects have changed outside of Terraform

Terraform detected the following changes made outside of Terraform since the last "terraform apply":

  # module.eks_blueprints.module.aws_eks.aws_security_group.cluster[0] has changed
  ~ resource "aws_security_group" "cluster" {
      ~ egress                 = [
          + {
              + cidr_blocks      = []
              + description      = "Cluster API to node groups"
              + from_port        = 443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = [
                  + "sg-0f670a1c8e36994c1",
                ]
              + self             = false
              + to_port          = 443
            },
          + {
              + cidr_blocks      = []
              + description      = "Cluster API to node kubelets"
              + from_port        = 10250
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = [
                  + "sg-0f670a1c8e36994c1",
                ]
              + self             = false
              + to_port          = 10250
            },
            # (2 unchanged elements hidden)
        ]
        id                     = "sg-02e6be5a34ccda5f7"
      ~ ingress                = [
          + {
              + cidr_blocks      = []
              + description      = "Node groups to cluster API"
              + from_port        = 443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = [
                  + "sg-0f670a1c8e36994c1",
                ]
              + self             = false
              + to_port          = 443
            },
            # (1 unchanged element hidden)
        ]
        name                   = "eks-lab-cluster-20230422000758683400000001"
        tags                   = {
            "Blueprint"  = "eks-lab"
            "GithubRepo" = "github.com/aws-ia/terraform-aws-eks-blueprints"
            "Name"       = "eks-lab-cluster"
        }
        # (7 unchanged attributes hidden)
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group.node[0] has changed
  ~ resource "aws_security_group" "node" {
      ~ egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "Egress NTP/TCP to internet"
              + from_port        = 123
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 123
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "Egress NTP/UDP to internet"
              + from_port        = 123
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "udp"
              + security_groups  = []
              + self             = false
              + to_port          = 123
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "Egress all HTTPS to internet"
              + from_port        = 443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 443
            },
          + {
              + cidr_blocks      = []
              + description      = "Node groups to cluster API"
              + from_port        = 443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = [
                  + "sg-02e6be5a34ccda5f7",
                ]
              + self             = false
              + to_port          = 443
            },
          + {
              + cidr_blocks      = []
              + description      = "Node to node CoreDNS"
              + from_port        = 53
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = true
              + to_port          = 53
            },
          + {
              + cidr_blocks      = []
              + description      = "Node to node CoreDNS"
              + from_port        = 53
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "udp"
              + security_groups  = []
              + self             = true
              + to_port          = 53
            },
        ]
        id                     = "sg-0f670a1c8e36994c1"
      ~ ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 8080
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8080
            },
          + {
              + cidr_blocks      = []
              + description      = "Cluster API to node groups"
              + from_port        = 443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = [
                  + "sg-02e6be5a34ccda5f7",
                ]
              + self             = false
              + to_port          = 443
            },
          + {
              + cidr_blocks      = []
              + description      = "Cluster API to node kubelets"
              + from_port        = 10250
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = [
                  + "sg-02e6be5a34ccda5f7",
                ]
              + self             = false
              + to_port          = 10250
            },
          + {
              + cidr_blocks      = []
              + description      = "Node to node CoreDNS"
              + from_port        = 53
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = true
              + to_port          = 53
            },
          + {
              + cidr_blocks      = []
              + description      = "Node to node CoreDNS"
              + from_port        = 53
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "udp"
              + security_groups  = []
              + self             = true
              + to_port          = 53
            },
        ]
        name                   = "my-eks-node-security-group"
        tags                   = {
            "Blueprint"                     = "eks-lab"
            "Environment"                   = "dev"
            "GithubRepo"                    = "github.com/aws-ia/terraform-aws-eks-blueprints"
            "Name"                          = "my-eks-node-security-group"
            "Terraform"                     = "true"
            "kubernetes.io/cluster/eks-lab" = "owned"
        }
        # (6 unchanged attributes hidden)
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["egress_nodes_443"] has changed
  ~ resource "aws_security_group_rule" "cluster" {
        id                       = "sgrule-3848468000"
      ~ security_group_rule_id   = "sgr-0b4a45d30706b2be3" -> "sgr-0680b9c07d13dad6e"
        # (9 unchanged attributes hidden)
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_self_coredns_udp"] has changed
  ~ resource "aws_security_group_rule" "node" {
        id                     = "sgrule-1584882114"
      ~ security_group_rule_id = "sgr-0e06c5b99deebd4d9" -> "sgr-08ba4ed9742b09734"
        # (8 unchanged attributes hidden)
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_example"] has changed
  ~ resource "aws_security_group_rule" "node" {
        id                     = "sgrule-3038877186"
        # (9 unchanged attributes hidden)
    }


Unless you have made equivalent changes to your configuration, or ignored the relevant attributes using ignore_changes, the following plan may include actions to undo or respond to
these changes.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  ~ update in-place
  - destroy
 <= read (data resources)

Terraform will perform the following actions:

  # module.kubernetes_addons.data.aws_caller_identity.current will be read during apply
  # (config refers to values not yet known)
 <= data "aws_caller_identity" "current"  {
      + account_id = (known after apply)
      + arn        = (known after apply)
      + id         = (known after apply)
      + user_id    = (known after apply)
    }

  # module.kubernetes_addons.data.aws_eks_cluster.eks_cluster will be read during apply
  # (config refers to values not yet known)
 <= data "aws_eks_cluster" "eks_cluster"  {
      + arn                       = (known after apply)
      + certificate_authority     = (known after apply)
      + cluster_id                = (known after apply)
      + created_at                = (known after apply)
      + enabled_cluster_log_types = (known after apply)
      + endpoint                  = (known after apply)
      + id                        = (known after apply)
      + identity                  = (known after apply)
      + kubernetes_network_config = (known after apply)
      + name                      = "eks-lab"
      + outpost_config            = (known after apply)
      + platform_version          = (known after apply)
      + role_arn                  = (known after apply)
      + status                    = (known after apply)
      + tags                      = (known after apply)
      + version                   = (known after apply)
      + vpc_config                = (known after apply)
    }

  # module.kubernetes_addons.data.aws_partition.current will be read during apply
  # (config refers to values not yet known)
 <= data "aws_partition" "current"  {
      + dns_suffix         = (known after apply)
      + id                 = (known after apply)
      + partition          = (known after apply)
      + reverse_dns_prefix = (known after apply)
    }

  # module.kubernetes_addons.data.aws_region.current will be read during apply
  # (config refers to values not yet known)
 <= data "aws_region" "current"  {
      + description = (known after apply)
      + endpoint    = (known after apply)
      + id          = (known after apply)
      + name        = (known after apply)
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group.node[0] (deposed object f555d40c) will be destroyed
  # (left over from a partially-failed replacement of this instance)
  - resource "aws_security_group" "node" {
      - arn                    = "arn:aws:ec2:us-east-1:261106957109:security-group/sg-05419262c58b82268" -> null
      - description            = "EKS node shared security group" -> null
      - egress                 = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = "Egress NTP/TCP to internet"
              - from_port        = 123
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 123
            },
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = "Egress NTP/UDP to internet"
              - from_port        = 123
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "udp"
              - security_groups  = []
              - self             = false
              - to_port          = 123
            },
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = "Egress all HTTPS to internet"
              - from_port        = 443
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 443
            },
          - {
              - cidr_blocks      = []
              - description      = "Node groups to cluster API"
              - from_port        = 443
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = [
                  - "sg-02e6be5a34ccda5f7",
                ]
              - self             = false
              - to_port          = 443
            },
          - {
              - cidr_blocks      = []
              - description      = "Node to node CoreDNS"
              - from_port        = 53
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = true
              - to_port          = 53
            },
          - {
              - cidr_blocks      = []
              - description      = "Node to node CoreDNS"
              - from_port        = 53
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "udp"
              - security_groups  = []
              - self             = true
              - to_port          = 53
            },
        ] -> null
      - id                     = "sg-05419262c58b82268" -> null
      - ingress                = [
          - {
              - cidr_blocks      = []
              - description      = "Cluster API to node groups"
              - from_port        = 443
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = [
                  - "sg-02e6be5a34ccda5f7",
                ]
              - self             = false
              - to_port          = 443
            },
          - {
              - cidr_blocks      = []
              - description      = "Cluster API to node kubelets"
              - from_port        = 10250
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = [
                  - "sg-02e6be5a34ccda5f7",
                ]
              - self             = false
              - to_port          = 10250
            },
          - {
              - cidr_blocks      = []
              - description      = "Node to node CoreDNS"
              - from_port        = 53
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = true
              - to_port          = 53
            },
          - {
              - cidr_blocks      = []
              - description      = "Node to node CoreDNS"
              - from_port        = 53
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "udp"
              - security_groups  = []
              - self             = true
              - to_port          = 53
            },
        ] -> null
      - name                   = "eks-lab-node-20230422000758685700000002" -> null
      - name_prefix            = "eks-lab-node-" -> null
      - owner_id               = "261106957109" -> null
      - revoke_rules_on_delete = false -> null
      - tags                   = {
          - "Blueprint"                     = "eks-lab"
          - "GithubRepo"                    = "github.com/aws-ia/terraform-aws-eks-blueprints"
          - "Name"                          = "eks-lab-node"
          - "kubernetes.io/cluster/eks-lab" = "owned"
        } -> null
      - tags_all               = {
          - "Blueprint"                     = "eks-lab"
          - "GithubRepo"                    = "github.com/aws-ia/terraform-aws-eks-blueprints"
          - "Name"                          = "eks-lab-node"
          - "kubernetes.io/cluster/eks-lab" = "owned"
        } -> null
      - vpc_id                 = "vpc-06ce67bba86f683c1" -> null
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["egress_nodes_443"] (deposed object 0a1b86ad) will be destroyed
  # (left over from a partially-failed replacement of this instance)
  - resource "aws_security_group_rule" "cluster" {
      - description              = "Cluster API to node groups" -> null
      - from_port                = 443 -> null
      - id                       = "sgrule-3935461898" -> null
      - prefix_list_ids          = [] -> null
      - protocol                 = "tcp" -> null
      - security_group_id        = "sg-02e6be5a34ccda5f7" -> null
      - security_group_rule_id   = "sgr-007afce860ffc6f19" -> null
      - self                     = false -> null
      - source_security_group_id = "sg-05419262c58b82268" -> null
      - to_port                  = 443 -> null
      - type                     = "egress" -> null
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["egress_nodes_kubelet"] (deposed object fdd872c2) will be destroyed
  # (left over from a partially-failed replacement of this instance)
  - resource "aws_security_group_rule" "cluster" {
      - description              = "Cluster API to node kubelets" -> null
      - from_port                = 10250 -> null
      - id                       = "sgrule-3081823999" -> null
      - prefix_list_ids          = [] -> null
      - protocol                 = "tcp" -> null
      - security_group_id        = "sg-02e6be5a34ccda5f7" -> null
      - security_group_rule_id   = "sgr-0347682517ef30c21" -> null
      - self                     = false -> null
      - source_security_group_id = "sg-05419262c58b82268" -> null
      - to_port                  = 10250 -> null
      - type                     = "egress" -> null
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["ingress_nodes_443"] (deposed object 508207ad) will be destroyed
  # (left over from a partially-failed replacement of this instance)
  - resource "aws_security_group_rule" "cluster" {
      - description              = "Node groups to cluster API" -> null
      - from_port                = 443 -> null
      - id                       = "sgrule-695323498" -> null
      - prefix_list_ids          = [] -> null
      - protocol                 = "tcp" -> null
      - security_group_id        = "sg-02e6be5a34ccda5f7" -> null
      - security_group_rule_id   = "sgr-007afce860ffc6f19" -> null
      - self                     = false -> null
      - source_security_group_id = "sg-05419262c58b82268" -> null
      - to_port                  = 443 -> null
      - type                     = "ingress" -> null
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_cluster_443"] (deposed object c23413c1) will be destroyed
  # (left over from a partially-failed replacement of this instance)
  - resource "aws_security_group_rule" "node" {
      - description              = "Node groups to cluster API" -> null
      - from_port                = 443 -> null
      - id                       = "sgrule-1487053307" -> null
      - prefix_list_ids          = [] -> null
      - protocol                 = "tcp" -> null
      - security_group_id        = "sg-05419262c58b82268" -> null
      - security_group_rule_id   = "sgr-0178d95e9f8a25a6f" -> null
      - self                     = false -> null
      - source_security_group_id = "sg-02e6be5a34ccda5f7" -> null
      - to_port                  = 443 -> null
      - type                     = "egress" -> null
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_example"] will be created
  + resource "aws_security_group_rule" "node" {
      + cidr_blocks              = [
          + "0.0.0.0/0",
        ]
      + from_port                = 30093
      + id                       = (known after apply)
      + prefix_list_ids          = []
      + protocol                 = "tcp"
      + security_group_id        = "sg-0f670a1c8e36994c1"
      + security_group_rule_id   = (known after apply)
      + self                     = false
      + source_security_group_id = (known after apply)
      + to_port                  = 30093
      + type                     = "egress"
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_https"] (deposed object 0a4c5768) will be destroyed
  # (left over from a partially-failed replacement of this instance)
  - resource "aws_security_group_rule" "node" {
      - cidr_blocks            = [
          - "0.0.0.0/0",
        ] -> null
      - description            = "Egress all HTTPS to internet" -> null
      - from_port              = 443 -> null
      - id                     = "sgrule-819437882" -> null
      - prefix_list_ids        = [] -> null
      - protocol               = "tcp" -> null
      - security_group_id      = "sg-05419262c58b82268" -> null
      - security_group_rule_id = "sgr-0dee1361380927e0b" -> null
      - self                   = false -> null
      - to_port                = 443 -> null
      - type                   = "egress" -> null
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_ntp_tcp"] (deposed object f10922f1) will be destroyed
  # (left over from a partially-failed replacement of this instance)
  - resource "aws_security_group_rule" "node" {
      - cidr_blocks            = [
          - "0.0.0.0/0",
        ] -> null
      - description            = "Egress NTP/TCP to internet" -> null
      - from_port              = 123 -> null
      - id                     = "sgrule-4010384420" -> null
      - prefix_list_ids        = [] -> null
      - protocol               = "tcp" -> null
      - security_group_id      = "sg-05419262c58b82268" -> null
      - security_group_rule_id = "sgr-0094d7a00f7a95cff" -> null
      - self                   = false -> null
      - to_port                = 123 -> null
      - type                   = "egress" -> null
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_ntp_udp"] (deposed object b526a1b7) will be destroyed
  # (left over from a partially-failed replacement of this instance)
  - resource "aws_security_group_rule" "node" {
      - cidr_blocks            = [
          - "0.0.0.0/0",
        ] -> null
      - description            = "Egress NTP/UDP to internet" -> null
      - from_port              = 123 -> null
      - id                     = "sgrule-2442639657" -> null
      - prefix_list_ids        = [] -> null
      - protocol               = "udp" -> null
      - security_group_id      = "sg-05419262c58b82268" -> null
      - security_group_rule_id = "sgr-0f86a146dfbbbb05e" -> null
      - self                   = false -> null
      - to_port                = 123 -> null
      - type                   = "egress" -> null
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_self_coredns_tcp"] (deposed object 3b6a7f95) will be destroyed
  # (left over from a partially-failed replacement of this instance)
  - resource "aws_security_group_rule" "node" {
      - description            = "Node to node CoreDNS" -> null
      - from_port              = 53 -> null
      - id                     = "sgrule-3591147875" -> null
      - prefix_list_ids        = [] -> null
      - protocol               = "tcp" -> null
      - security_group_id      = "sg-05419262c58b82268" -> null
      - security_group_rule_id = "sgr-094359908134c5d0a" -> null
      - self                   = true -> null
      - to_port                = 53 -> null
      - type                   = "egress" -> null
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_self_coredns_udp"] (deposed object c192202e) will be destroyed
  # (left over from a partially-failed replacement of this instance)
  - resource "aws_security_group_rule" "node" {
      - description            = "Node to node CoreDNS" -> null
      - from_port              = 53 -> null
      - id                     = "sgrule-1483412229" -> null
      - prefix_list_ids        = [] -> null
      - protocol               = "udp" -> null
      - security_group_id      = "sg-05419262c58b82268" -> null
      - security_group_rule_id = "sgr-052dfa3f1e4c75a87" -> null
      - self                   = true -> null
      - to_port                = 53 -> null
      - type                   = "egress" -> null
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_cluster_443"] (deposed object c5b6d455) will be destroyed
  # (left over from a partially-failed replacement of this instance)
  - resource "aws_security_group_rule" "node" {
      - description              = "Cluster API to node groups" -> null
      - from_port                = 443 -> null
      - id                       = "sgrule-4177801947" -> null
      - prefix_list_ids          = [] -> null
      - protocol                 = "tcp" -> null
      - security_group_id        = "sg-05419262c58b82268" -> null
      - security_group_rule_id   = "sgr-0178d95e9f8a25a6f" -> null
      - self                     = false -> null
      - source_security_group_id = "sg-02e6be5a34ccda5f7" -> null
      - to_port                  = 443 -> null
      - type                     = "ingress" -> null
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_cluster_kubelet"] (deposed object 27150a2d) will be destroyed
  # (left over from a partially-failed replacement of this instance)
  - resource "aws_security_group_rule" "node" {
      - description              = "Cluster API to node kubelets" -> null
      - from_port                = 10250 -> null
      - id                       = "sgrule-3147465503" -> null
      - prefix_list_ids          = [] -> null
      - protocol                 = "tcp" -> null
      - security_group_id        = "sg-05419262c58b82268" -> null
      - security_group_rule_id   = "sgr-0f789239462b2de67" -> null
      - self                     = false -> null
      - source_security_group_id = "sg-02e6be5a34ccda5f7" -> null
      - to_port                  = 10250 -> null
      - type                     = "ingress" -> null
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_self_coredns_tcp"] (deposed object 662c48b5) will be destroyed
  # (left over from a partially-failed replacement of this instance)
  - resource "aws_security_group_rule" "node" {
      - description            = "Node to node CoreDNS" -> null
      - from_port              = 53 -> null
      - id                     = "sgrule-488868965" -> null
      - prefix_list_ids        = [] -> null
      - protocol               = "tcp" -> null
      - security_group_id      = "sg-05419262c58b82268" -> null
      - security_group_rule_id = "sgr-0e55fc2d0e2f760a5" -> null
      - self                   = true -> null
      - to_port                = 53 -> null
      - type                   = "ingress" -> null
    }

  # module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_self_coredns_udp"] (deposed object b3c7ec09) will be destroyed
  # (left over from a partially-failed replacement of this instance)
  - resource "aws_security_group_rule" "node" {
      - description            = "Node to node CoreDNS" -> null
      - from_port              = 53 -> null
      - id                     = "sgrule-3111923594" -> null
      - prefix_list_ids        = [] -> null
      - protocol               = "udp" -> null
      - security_group_id      = "sg-05419262c58b82268" -> null
      - security_group_rule_id = "sgr-087447b86b77898da" -> null
      - self                   = true -> null
      - to_port                = 53 -> null
      - type                   = "ingress" -> null
    }

  # module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_NODE2"].data.aws_iam_policy_document.managed_ng_assume_role_policy will be read during apply
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

  # module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_NODE2"].aws_iam_role.managed_ng[0] will be updated in-place
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
        id                    = "eks-lab-teste2"
        name                  = "eks-lab-teste2"
        tags                  = {
            "Blueprint"  = "eks-lab"
            "GithubRepo" = "github.com/aws-ia/terraform-aws-eks-blueprints"
        }
        # (9 unchanged attributes hidden)
    }

  # module.kubernetes_addons.module.aws_ebs_csi_driver[0].data.aws_eks_addon_version.this will be read during apply
  # (config refers to values not yet known)
 <= data "aws_eks_addon_version" "this"  {
      + addon_name         = "aws-ebs-csi-driver"
      + id                 = (known after apply)
      + kubernetes_version = (known after apply)
      + most_recent        = false
      + version            = (known after apply)
    }

  # module.kubernetes_addons.module.aws_ebs_csi_driver[0].data.aws_iam_policy_document.aws_ebs_csi_driver[0] will be read during apply
  # (config refers to values not yet known)
 <= data "aws_iam_policy_document" "aws_ebs_csi_driver"  {
      + id   = (known after apply)
      + json = (known after apply)

      + statement {
          + actions   = [
              + "ec2:AttachVolume",
              + "ec2:CreateSnapshot",
              + "ec2:DescribeAvailabilityZones",
              + "ec2:DescribeInstances",
              + "ec2:DescribeSnapshots",
              + "ec2:DescribeTags",
              + "ec2:DescribeVolumes",
              + "ec2:DescribeVolumesModifications",
              + "ec2:DetachVolume",
              + "ec2:ModifyVolume",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]
        }
      + statement {
          + actions   = [
              + "ec2:CreateTags",
            ]
          + effect    = "Allow"
          + resources = [
              + (known after apply),
              + (known after apply),
            ]

          + condition {
              + test     = "StringEquals"
              + values   = [
                  + "CreateVolume",
                  + "CreateSnapshot",
                ]
              + variable = "ec2:CreateAction"
            }
        }
      + statement {
          + actions   = [
              + "ec2:DeleteTags",
            ]
          + effect    = "Allow"
          + resources = [
              + (known after apply),
              + (known after apply),
            ]
        }
      + statement {
          + actions   = [
              + "ec2:CreateVolume",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]

          + condition {
              + test     = "StringLike"
              + values   = [
                  + "true",
                ]
              + variable = "aws:RequestTag/ebs.csi.aws.com/cluster"
            }
        }
      + statement {
          + actions   = [
              + "ec2:CreateVolume",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]

          + condition {
              + test     = "StringLike"
              + values   = [
                  + "*",
                ]
              + variable = "aws:RequestTag/CSIVolumeName"
            }
        }
      + statement {
          + actions   = [
              + "ec2:CreateVolume",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]

          + condition {
              + test     = "StringLike"
              + values   = [
                  + "owned",
                ]
              + variable = "aws:RequestTag/kubernetes.io/cluster/*"
            }
        }
      + statement {
          + actions   = [
              + "ec2:DeleteVolume",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]

          + condition {
              + test     = "StringLike"
              + values   = [
                  + "true",
                ]
              + variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
            }
        }
      + statement {
          + actions   = [
              + "ec2:DeleteVolume",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]

          + condition {
              + test     = "StringLike"
              + values   = [
                  + "*",
                ]
              + variable = "ec2:ResourceTag/CSIVolumeName"
            }
        }
      + statement {
          + actions   = [
              + "ec2:DeleteVolume",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]

          + condition {
              + test     = "StringLike"
              + values   = [
                  + "owned",
                ]
              + variable = "ec2:ResourceTag/kubernetes.io/cluster/*"
            }
        }
      + statement {
          + actions   = [
              + "ec2:DeleteSnapshot",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]

          + condition {
              + test     = "StringLike"
              + values   = [
                  + "*",
                ]
              + variable = "ec2:ResourceTag/CSIVolumeSnapshotName"
            }
        }
      + statement {
          + actions   = [
              + "ec2:DeleteSnapshot",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]

          + condition {
              + test     = "StringLike"
              + values   = [
                  + "true",
                ]
              + variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
            }
        }
    }

  # module.kubernetes_addons.module.aws_ebs_csi_driver[0].aws_eks_addon.aws_ebs_csi_driver[0] will be created
  + resource "aws_eks_addon" "aws_ebs_csi_driver" {
      + addon_name               = "aws-ebs-csi-driver"
      + addon_version            = (known after apply)
      + arn                      = (known after apply)
      + cluster_name             = (known after apply)
      + configuration_values     = (known after apply)
      + created_at               = (known after apply)
      + id                       = (known after apply)
      + modified_at              = (known after apply)
      + preserve                 = true
      + resolve_conflicts        = "OVERWRITE"
      + service_account_role_arn = (known after apply)
      + tags_all                 = (known after apply)
    }

  # module.kubernetes_addons.module.aws_ebs_csi_driver[0].aws_iam_policy.aws_ebs_csi_driver[0] will be created
  + resource "aws_iam_policy" "aws_ebs_csi_driver" {
      + arn         = (known after apply)
      + description = "IAM Policy for AWS EBS CSI Driver"
      + id          = (known after apply)
      + name        = (known after apply)
      + name_prefix = (known after apply)
      + path        = "/"
      + policy      = (known after apply)
      + policy_id   = (known after apply)
      + tags_all    = (known after apply)
    }

  # module.kubernetes_addons.module.aws_load_balancer_controller[0].data.aws_iam_policy_document.aws_lb will be read during apply
  # (config refers to values not yet known)
 <= data "aws_iam_policy_document" "aws_lb"  {
      + id   = (known after apply)
      + json = (known after apply)

      + statement {
          + actions   = [
              + "iam:CreateServiceLinkedRole",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]

          + condition {
              + test     = "StringEquals"
              + values   = [
                  + "elasticloadbalancing.amazonaws.com",
                ]
              + variable = "iam:AWSServiceName"
            }
        }
      + statement {
          + actions   = [
              + "ec2:DescribeAccountAttributes",
              + "ec2:DescribeAddresses",
              + "ec2:DescribeAvailabilityZones",
              + "ec2:DescribeCoipPools",
              + "ec2:DescribeInstances",
              + "ec2:DescribeInternetGateways",
              + "ec2:DescribeNetworkInterfaces",
              + "ec2:DescribeSecurityGroups",
              + "ec2:DescribeSubnets",
              + "ec2:DescribeTags",
              + "ec2:DescribeVpcPeeringConnections",
              + "ec2:DescribeVpcs",
              + "ec2:GetCoipPoolUsage",
              + "elasticloadbalancing:DescribeListenerCertificates",
              + "elasticloadbalancing:DescribeListeners",
              + "elasticloadbalancing:DescribeLoadBalancerAttributes",
              + "elasticloadbalancing:DescribeLoadBalancers",
              + "elasticloadbalancing:DescribeRules",
              + "elasticloadbalancing:DescribeSSLPolicies",
              + "elasticloadbalancing:DescribeTags",
              + "elasticloadbalancing:DescribeTargetGroupAttributes",
              + "elasticloadbalancing:DescribeTargetGroups",
              + "elasticloadbalancing:DescribeTargetHealth",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]
        }
      + statement {
          + actions   = [
              + "acm:DescribeCertificate",
              + "acm:ListCertificates",
              + "cognito-idp:DescribeUserPoolClient",
              + "iam:GetServerCertificate",
              + "iam:ListServerCertificates",
              + "shield:CreateProtection",
              + "shield:DeleteProtection",
              + "shield:DescribeProtection",
              + "shield:GetSubscriptionState",
              + "waf-regional:AssociateWebACL",
              + "waf-regional:DisassociateWebACL",
              + "waf-regional:GetWebACL",
              + "waf-regional:GetWebACLForResource",
              + "wafv2:AssociateWebACL",
              + "wafv2:DisassociateWebACL",
              + "wafv2:GetWebACL",
              + "wafv2:GetWebACLForResource",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]
        }
      + statement {
          + actions   = [
              + "ec2:AuthorizeSecurityGroupIngress",
              + "ec2:RevokeSecurityGroupIngress",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]
        }
      + statement {
          + actions   = [
              + "ec2:CreateSecurityGroup",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]
        }
      + statement {
          + actions   = [
              + "ec2:CreateTags",
            ]
          + effect    = "Allow"
          + resources = [
              + (known after apply),
            ]

          + condition {
              + test     = "Null"
              + values   = [
                  + "false",
                ]
              + variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
            }
          + condition {
              + test     = "StringEquals"
              + values   = [
                  + "CreateSecurityGroup",
                ]
              + variable = "ec2:CreateAction"
            }
        }
      + statement {
          + actions   = [
              + "ec2:CreateTags",
              + "ec2:DeleteTags",
            ]
          + effect    = "Allow"
          + resources = [
              + (known after apply),
            ]

          + condition {
              + test     = "Null"
              + values   = [
                  + "false",
                ]
              + variable = "aws:ResourceTag/ingress.k8s.aws/cluster"
            }
        }
      + statement {
          + actions   = [
              + "elasticloadbalancing:AddTags",
              + "elasticloadbalancing:DeleteTargetGroup",
              + "elasticloadbalancing:RemoveTags",
            ]
          + effect    = "Allow"
          + resources = [
              + (known after apply),
              + (known after apply),
              + (known after apply),
            ]

          + condition {
              + test     = "Null"
              + values   = [
                  + "false",
                ]
              + variable = "aws:ResourceTag/ingress.k8s.aws/cluster"
            }
        }
      + statement {
          + actions   = [
              + "ec2:CreateTags",
              + "ec2:DeleteTags",
            ]
          + effect    = "Allow"
          + resources = [
              + (known after apply),
            ]

          + condition {
              + test     = "Null"
              + values   = [
                  + "false",
                ]
              + variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
            }
          + condition {
              + test     = "Null"
              + values   = [
                  + "true",
                ]
              + variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
            }
        }
      + statement {
          + actions   = [
              + "ec2:AuthorizeSecurityGroupIngress",
              + "ec2:DeleteSecurityGroup",
              + "ec2:RevokeSecurityGroupIngress",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]

          + condition {
              + test     = "Null"
              + values   = [
                  + "false",
                ]
              + variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
            }
        }
      + statement {
          + actions   = [
              + "elasticloadbalancing:CreateLoadBalancer",
              + "elasticloadbalancing:CreateTargetGroup",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]

          + condition {
              + test     = "Null"
              + values   = [
                  + "false",
                ]
              + variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
            }
        }
      + statement {
          + actions   = [
              + "elasticloadbalancing:CreateListener",
              + "elasticloadbalancing:CreateRule",
              + "elasticloadbalancing:DeleteListener",
              + "elasticloadbalancing:DeleteRule",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]
        }
      + statement {
          + actions   = [
              + "elasticloadbalancing:AddTags",
              + "elasticloadbalancing:RemoveTags",
            ]
          + effect    = "Allow"
          + resources = [
              + (known after apply),
              + (known after apply),
              + (known after apply),
            ]

          + condition {
              + test     = "Null"
              + values   = [
                  + "false",
                ]
              + variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
            }
          + condition {
              + test     = "Null"
              + values   = [
                  + "true",
                ]
              + variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
            }
        }
      + statement {
          + actions   = [
              + "elasticloadbalancing:AddTags",
              + "elasticloadbalancing:RemoveTags",
            ]
          + effect    = "Allow"
          + resources = [
              + (known after apply),
              + (known after apply),
              + (known after apply),
              + (known after apply),
            ]
        }
      + statement {
          + actions   = [
              + "elasticloadbalancing:DeleteLoadBalancer",
              + "elasticloadbalancing:DeleteTargetGroup",
              + "elasticloadbalancing:ModifyLoadBalancerAttributes",
              + "elasticloadbalancing:ModifyTargetGroup",
              + "elasticloadbalancing:ModifyTargetGroupAttributes",
              + "elasticloadbalancing:SetIpAddressType",
              + "elasticloadbalancing:SetSecurityGroups",
              + "elasticloadbalancing:SetSubnets",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]

          + condition {
              + test     = "Null"
              + values   = [
                  + "false",
                ]
              + variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
            }
        }
      + statement {
          + actions   = [
              + "elasticloadbalancing:DeregisterTargets",
              + "elasticloadbalancing:RegisterTargets",
            ]
          + effect    = "Allow"
          + resources = [
              + (known after apply),
            ]
        }
      + statement {
          + actions   = [
              + "elasticloadbalancing:AddListenerCertificates",
              + "elasticloadbalancing:ModifyListener",
              + "elasticloadbalancing:ModifyRule",
              + "elasticloadbalancing:RemoveListenerCertificates",
              + "elasticloadbalancing:SetWebAcl",
            ]
          + effect    = "Allow"
          + resources = [
              + "*",
            ]
        }
    }

  # module.kubernetes_addons.module.aws_load_balancer_controller[0].aws_iam_policy.aws_load_balancer_controller will be created
  + resource "aws_iam_policy" "aws_load_balancer_controller" {
      + arn         = (known after apply)
      + description = "Allows lb controller to manage ALB and NLB"
      + id          = (known after apply)
      + name        = (known after apply)
      + name_prefix = (known after apply)
      + path        = "/"
      + policy      = (known after apply)
      + policy_id   = (known after apply)
      + tags_all    = (known after apply)
    }

  # module.kubernetes_addons.module.aws_ebs_csi_driver[0].module.irsa_addon[0].aws_iam_role.irsa[0] will be created
  + resource "aws_iam_role" "irsa" {
      + arn                   = (known after apply)
      + assume_role_policy    = (known after apply)
      + create_date           = (known after apply)
      + description           = "AWS IAM Role for the Kubernetes service account ebs-csi-controller-sa."
      + force_detach_policies = true
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = (known after apply)
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)

      + inline_policy {
          + name   = (known after apply)
          + policy = (known after apply)
        }
    }

  # module.kubernetes_addons.module.aws_ebs_csi_driver[0].module.irsa_addon[0].aws_iam_role_policy_attachment.irsa[0] will be created
  + resource "aws_iam_role_policy_attachment" "irsa" {
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + role       = (known after apply)
    }

  # module.kubernetes_addons.module.aws_load_balancer_controller[0].module.helm_addon.helm_release.addon[0] will be updated in-place
  ~ resource "helm_release" "addon" {
        id                         = "aws-load-balancer-controller"
        name                       = "aws-load-balancer-controller"
      ~ values                     = [
          - <<-EOT
                clusterName: eks-lab
                region: us-east-1
                image:
                  repository: 602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon/aws-load-balancer-controller
            EOT,
        ] -> (known after apply)
        # (28 unchanged attributes hidden)


        # (3 unchanged blocks hidden)
    }

  # module.kubernetes_addons.module.aws_load_balancer_controller[0].module.helm_addon.module.irsa[0].aws_iam_role.irsa[0] will be created
  + resource "aws_iam_role" "irsa" {
      + arn                   = (known after apply)
      + assume_role_policy    = (known after apply)
      + create_date           = (known after apply)
      + description           = "AWS IAM Role for the Kubernetes service account aws-load-balancer-controller-sa."
      + force_detach_policies = true
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = (known after apply)
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)

      + inline_policy {
          + name   = (known after apply)
          + policy = (known after apply)
        }
    }

  # module.kubernetes_addons.module.aws_load_balancer_controller[0].module.helm_addon.module.irsa[0].aws_iam_role_policy_attachment.irsa[0] will be created
  + resource "aws_iam_role_policy_attachment" "irsa" {
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + role       = (known after apply)
    }

  # module.kubernetes_addons.module.aws_load_balancer_controller[0].module.helm_addon.module.irsa[0].kubernetes_service_account_v1.irsa[0] will be updated in-place
  ~ resource "kubernetes_service_account_v1" "irsa" {
        id                              = "kube-system/aws-load-balancer-controller-sa"
        # (2 unchanged attributes hidden)

      ~ metadata {
          ~ annotations      = {
              - "eks.amazonaws.com/role-arn" = "arn:aws:iam::261106957109:role/eks-lab-aws-load-balancer-controller-sa-irsa"
            } -> (known after apply)
            name             = "aws-load-balancer-controller-sa"
            # (5 unchanged attributes hidden)
        }
    }

Plan: 8 to add, 3 to change, 14 to destroy.
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_example"]: Creating...
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_NODE2"].data.aws_iam_policy_document.managed_ng_assume_role_policy: Reading... [id=3778018924]
module.eks_blueprints.module.aws_eks_managed_node_groups["T3A_NODE2"].data.aws_iam_policy_document.managed_ng_assume_role_policy: Read complete after 0s [id=3778018924]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_example"]: Creation complete after 1s [id=sgrule-99950319]
module.kubernetes_addons.data.aws_partition.current: Reading...
module.kubernetes_addons.data.aws_region.current: Reading...
module.kubernetes_addons.data.aws_eks_cluster.eks_cluster: Reading...
module.kubernetes_addons.data.aws_caller_identity.current: Reading...
module.kubernetes_addons.data.aws_partition.current: Read complete after 0s [id=aws]
module.kubernetes_addons.data.aws_region.current: Read complete after 0s [id=us-east-1]
module.kubernetes_addons.data.aws_caller_identity.current: Read complete after 0s [id=261106957109]
module.kubernetes_addons.data.aws_eks_cluster.eks_cluster: Read complete after 0s [id=eks-lab]
module.kubernetes_addons.module.aws_ebs_csi_driver[0].data.aws_eks_addon_version.this: Reading...
module.kubernetes_addons.module.aws_ebs_csi_driver[0].data.aws_iam_policy_document.aws_ebs_csi_driver[0]: Reading...
module.kubernetes_addons.module.aws_load_balancer_controller[0].data.aws_iam_policy_document.aws_lb: Reading...
module.kubernetes_addons.module.aws_ebs_csi_driver[0].data.aws_iam_policy_document.aws_ebs_csi_driver[0]: Read complete after 0s [id=1888929143]
module.kubernetes_addons.module.aws_load_balancer_controller[0].data.aws_iam_policy_document.aws_lb: Read complete after 0s [id=2633998141]
module.kubernetes_addons.module.aws_ebs_csi_driver[0].aws_iam_policy.aws_ebs_csi_driver[0]: Creating...
module.kubernetes_addons.module.aws_load_balancer_controller[0].aws_iam_policy.aws_load_balancer_controller: Creating...
module.kubernetes_addons.module.aws_ebs_csi_driver[0].data.aws_eks_addon_version.this: Read complete after 1s [id=aws-ebs-csi-driver]
module.kubernetes_addons.module.aws_ebs_csi_driver[0].aws_iam_policy.aws_ebs_csi_driver[0]: Creation complete after 1s [id=arn:aws:iam::261106957109:policy/eks-lab-aws-ebs-csi-driver-irsa]
module.kubernetes_addons.module.aws_load_balancer_controller[0].aws_iam_policy.aws_load_balancer_controller: Creation complete after 1s [id=arn:aws:iam::261106957109:policy/eks-lab-lb-irsa]
module.kubernetes_addons.module.aws_ebs_csi_driver[0].module.irsa_addon[0].aws_iam_role.irsa[0]: Creating...
module.kubernetes_addons.module.aws_load_balancer_controller[0].module.helm_addon.module.irsa[0].aws_iam_role.irsa[0]: Creating...
module.kubernetes_addons.module.aws_ebs_csi_driver[0].module.irsa_addon[0].aws_iam_role.irsa[0]: Creation complete after 1s [id=eks-lab-ebs-csi-controller-sa-irsa]
module.kubernetes_addons.module.aws_load_balancer_controller[0].module.helm_addon.module.irsa[0].aws_iam_role.irsa[0]: Creation complete after 1s [id=eks-lab-aws-load-balancer-controller-sa-irsa]
module.kubernetes_addons.module.aws_ebs_csi_driver[0].module.irsa_addon[0].aws_iam_role_policy_attachment.irsa[0]: Creating...
module.kubernetes_addons.module.aws_ebs_csi_driver[0].aws_eks_addon.aws_ebs_csi_driver[0]: Creating...
module.kubernetes_addons.module.aws_load_balancer_controller[0].module.helm_addon.module.irsa[0].aws_iam_role_policy_attachment.irsa[0]: Creating...
module.kubernetes_addons.module.aws_load_balancer_controller[0].module.helm_addon.module.irsa[0].aws_iam_role_policy_attachment.irsa[0]: Creation complete after 1s [id=eks-lab-aws-load-balancer-controller-sa-irsa-20230422020330544500000003]
module.kubernetes_addons.module.aws_ebs_csi_driver[0].module.irsa_addon[0].aws_iam_role_policy_attachment.irsa[0]: Creation complete after 1s [id=eks-lab-ebs-csi-controller-sa-irsa-20230422020330543300000002]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_ntp_tcp"] (deposed object f10922f1): Destroying... [id=sgrule-4010384420]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_self_coredns_tcp"] (deposed object 662c48b5): Destroying... [id=sgrule-488868965]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["egress_nodes_443"] (deposed object 0a1b86ad): Destroying... [id=sgrule-3935461898]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["ingress_nodes_443"] (deposed object 508207ad): Destroying... [id=sgrule-695323498]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_cluster_443"] (deposed object c5b6d455): Destroying... [id=sgrule-4177801947]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_self_coredns_tcp"] (deposed object 3b6a7f95): Destroying... [id=sgrule-3591147875]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_self_coredns_udp"] (deposed object c192202e): Destroying... [id=sgrule-1483412229]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_ntp_udp"] (deposed object b526a1b7): Destroying... [id=sgrule-2442639657]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["egress_nodes_kubelet"] (deposed object fdd872c2): Destroying... [id=sgrule-3081823999]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["egress_nodes_443"]: Destruction complete after 1s
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_https"] (deposed object 0a4c5768): Destroying... [id=sgrule-819437882]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_self_coredns_tcp"]: Destruction complete after 1s
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_self_coredns_udp"] (deposed object b3c7ec09): Destroying... [id=sgrule-3111923594]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_cluster_443"]: Destruction complete after 1s
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["ingress_nodes_443"]: Destruction complete after 1s
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_cluster_443"] (deposed object c23413c1): Destroying... [id=sgrule-1487053307]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_cluster_kubelet"] (deposed object 27150a2d): Destroying... [id=sgrule-3147465503]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_ntp_tcp"]: Destruction complete after 2s
module.eks_blueprints.module.aws_eks.aws_security_group_rule.cluster["egress_nodes_kubelet"]: Destruction complete after 2s
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_self_coredns_udp"]: Destruction complete after 3s
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_self_coredns_tcp"]: Destruction complete after 3s
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_ntp_udp"]: Destruction complete after 4s
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_https"]: Destruction complete after 4s
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_self_coredns_udp"]: Destruction complete after 5s
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["egress_cluster_443"]: Destruction complete after 5s
module.kubernetes_addons.module.aws_ebs_csi_driver[0].aws_eks_addon.aws_ebs_csi_driver[0]: Still creating... [10s elapsed]
module.eks_blueprints.module.aws_eks.aws_security_group_rule.node["ingress_cluster_kubelet"]: Destruction complete after 6s
module.eks_blueprints.module.aws_eks.aws_security_group.node[0] (deposed object f555d40c): Destroying... [id=sg-05419262c58b82268]
module.eks_blueprints.module.aws_eks.aws_security_group.node[0]: Destruction complete after 1s
module.kubernetes_addons.module.aws_ebs_csi_driver[0].aws_eks_addon.aws_ebs_csi_driver[0]: Creation complete after 17s [id=eks-lab:aws-ebs-csi-driver]

Apply complete! Resources: 8 added, 0 changed, 14 destroyed.

Outputs:

configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-06ce67bba86f683c1"

~~~~


module.kubernetes_addons.module.aws_ebs_csi_driver[0].aws_eks_addon.aws_ebs_csi_driver[0]: Creation complete after 17s [id=eks-lab:aws-ebs-csi-driver]

Apply complete! Resources: 8 added, 0 changed, 14 destroyed.

Outputs:

configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-06ce67bba86f683c1"
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$










- Como ficou a SG:

Inbound rules (5)

	Name
	Security group rule ID
	IP version
	Type
	Protocol
	Port range
	Source
	Description
	–	sgr-08ba4ed9742b09734	–	DNS (UDP)	UDP	53	sg-0f670a1c8e36994c1 / my-eks-node-security-group	Node to node CoreDNS
	–	sgr-0a2acc129c628638d	–	Custom TCP	TCP	10250	sg-02e6be5a34ccda5f7 / eks-lab-cluster-20230422000758683400000001	Cluster API to node kubelets
	–	sgr-0ad0e5516b3329b3d	IPv4	Custom TCP	TCP	8080	0.0.0.0/0	–
	–	sgr-096fd25b4deaa5ae8	–	HTTPS	TCP	443	sg-02e6be5a34ccda5f7 / eks-lab-cluster-20230422000758683400000001	Cluster API to node groups
	–	sgr-0b271297498934971	–	DNS (TCP)	TCP	53	sg-0f670a1c8e36994c1 / my-eks-node-security-group	Node to node CoreDNS


Outbound rules (1/7)

	Name
	Security group rule ID
	IP version
	Type
	Protocol
	Port range
	Destination
	Description
	–	sgr-0b9d7cc551ac45ae2	IPv4	Custom TCP	TCP	30093	0.0.0.0/0	–
	–	sgr-082322522da783e47	–	HTTPS	TCP	443	sg-02e6be5a34ccda5f7 / eks-lab-cluster-20230422000758683400000001	Node groups to cluster API
	–	sgr-0d30a55f25a4563d7	IPv4	HTTPS	TCP	443	0.0.0.0/0	Egress all HTTPS to internet
	–	sgr-0d3effd58f8023381	–	DNS (TCP)	TCP	53	sg-0f670a1c8e36994c1 / my-eks-node-security-group	Node to node CoreDNS
	–	sgr-0e06c5b99deebd4d9	–	DNS (UDP)	UDP	53	sg-0f670a1c8e36994c1 / my-eks-node-security-group	Node to node CoreDNS
	–	sgr-0fb34d3ed1417d022	IPv4	Custom UDP	UDP	123	0.0.0.0/0	Egress NTP/UDP to internet
	–	sgr-079de51d2ed632f53	IPv4	Custom TCP	TCP	123	0.0.0.0/0	Egress NTP/TCP to internet










- SG acima não é aplicada aos nodes.



- Testar a Cluster SG
https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/main.tf
<https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/main.tf>
  create_cluster_security_group           = var.create_cluster_security_group
  cluster_security_group_id               = var.cluster_security_group_id
  cluster_security_group_name             = var.cluster_security_group_name
  cluster_security_group_use_name_prefix  = var.cluster_security_group_use_name_prefix
  cluster_security_group_description      = var.cluster_security_group_description
  cluster_additional_security_group_ids   = var.cluster_additional_security_group_ids
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules
  cluster_security_group_tags             = var.cluster_security_group_tags



- EXEMPLO, atual que é atrelada aos Nodes:
eks-cluster-sg-eks-lab-1680437171	sg-0f552d7b44716d1ed	eks-cluster-sg-eks-lab-1680437171	vpc-06ce67bba86f683c1
	EKS created security group applied to ENI that is attached to EKS Control Plane master nodes, as well as any managed workloads.



- Exemplo da conf de SG nodes:

~~~~t

  # Configurações do módulo
  create_node_security_group           = true
  node_security_group_name             = "my-eks-node-security-group"
  node_security_group_use_name_prefix  = false
  node_security_group_description      = "My EKS Node Security Group"
  node_security_group_additional_rules = {
    # Exemplo de regra de ingresso
    ingress_example = {
      type        = "ingress"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Exemplo de regra de egresso
    egress_example = {
      type        = "egress"
      from_port   = 30093
      to_port     = 30093
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  node_security_group_tags = {
    Terraform   = "true"
    Environment = "dev"
  }

~~~~




- Exemplo para SG de Cluster:

~~~~t
# Configurações do módulo
  create_cluster_security_group           = true
  cluster_security_group_id               = "my-eks-cluster-security-group"
  cluster_security_group_name             = "my-eks-cluster-security-group"
  cluster_security_group_use_name_prefix  = false
  cluster_security_group_description      = "My EKS Cluster Security Group"
  cluster_additional_security_group_ids   = [aws_security_group.sg.id]
  cluster_security_group_additional_rules = {
    # Exemplo de regra de ingresso
    ingress_example = {
      type        = "ingress"
      from_port   = 8082
      to_port     = 8082
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Exemplo de regra de egresso
    egress_example = {
      type        = "egress"
      from_port   = 30094
      to_port     = 30094
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  cluster_security_group_tags = {
    Terraform   = "true"
    Environment = "dev"
  }
~~~~








- Erros ao tentar apply ou plan agora

~~~~bash

module.eks_blueprints.module.aws_eks_teams[0].aws_iam_role.platform_team["admin"]: Refreshing state... [id=eks-lab-admin-access]
╷
│ Error: Get "http://localhost/api/v1/namespaces/kube-system/configmaps/aws-auth": dial tcp [::1]:80: connect: connection refused
│
│   with module.eks_blueprints.kubernetes_config_map.aws_auth[0],
│   on .terraform/modules/eks_blueprints/aws-auth-configmap.tf line 1, in resource "kubernetes_config_map" "aws_auth":
│    1: resource "kubernetes_config_map" "aws_auth" {
│
╵
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$

~~~~


- Provável falha devido permissões que foram destruidas mais cedo, ç___ç'
- Provável falha devido permissões que foram destruidas mais cedo, ç___ç'
- Provável falha devido permissões que foram destruidas mais cedo, ç___ç'
- Provável falha devido permissões que foram destruidas mais cedo, ç___ç'










terraform destroy -target=module.kubernetes_addons -auto-approve
terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve



Security group name
eks-lab-cluster-20230422000758683400000001
Security group ID
sg-02e6be5a34ccda5f7

Inbound security group rules successfully modified on security group (sg-02e6be5a34ccda5f7 | eks-lab-cluster-20230422000758683400000001)
Details

    New









Inbound security group rules successfully modified on security group (sg-0f552d7b44716d1ed | eks-cluster-sg-eks-lab-1680437171)
Details

    New






module.eks_blueprints.module.aws_eks_teams[0].aws_iam_policy.platform_team_eks_access[0]: Refreshing state... [id=arn:aws:iam::261106957109:policy/eks-lab-PlatformTeamEKSAccess]
module.eks_blueprints.kubernetes_config_map.aws_auth[0]: Refreshing state... [id=kube-system/aws-auth]
module.eks_blueprints.module.aws_eks_teams[0].aws_iam_role.platform_team["admin"]: Refreshing state... [id=eks-lab-admin-access]
╷
│ Warning: Resource targeting is in effect
│
│ You are creating a plan with the -target option, which means that the result of this plan may not represent all of the changes requested by the current configuration.
│
│ The -target option is not for routine use, and is provided only for exceptional situations such as recovering from errors or mistakes, or when Terraform specifically suggests to use
│ it as part of an error message.
╵
╷
│ Error: Get "http://localhost/api/v1/namespaces/kube-system/configmaps/aws-auth": dial tcp [::1]:80: connect: connection refused
│
│   with module.eks_blueprints.kubernetes_config_map.aws_auth[0],
│   on .terraform/modules/eks_blueprints/aws-auth-configmap.tf line 1, in resource "kubernetes_config_map" "aws_auth":
│    1: resource "kubernetes_config_map" "aws_auth" {
│
╵
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$




 DimamoN commented Apr 25, 2022 •

Faced the same, then checked state using terraform state list and found k8s related entries there.
Then I removed then using

terraform state rm module.eks.kubernetes_config_map.aws_auth[0]

And that helped to resolve the issue.



fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ terraform state rm module.eks.kubernetes_config_map.aws_auth[0]
╷
│ Error: Invalid target address
│
│ No matching objects found. To view the available instances, use "terraform state list". Please modify the address to reference a specific instance.
╵

fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$





terraform state rm module.eks_blueprints.kubernetes_config_map.aws_auth[0]


fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$ terraform state rm module.eks_blueprints.kubernetes_config_map.aws_auth[0]
Removed module.eks_blueprints.kubernetes_config_map.aws_auth[0]
Successfully removed 1 resource instance(s).
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$





│ Warning: Resource targeting is in effect
│
│ You are creating a plan with the -target option, which means that the result of this plan may not represent all of the changes requested by the current configuration.
│
│ The -target option is not for routine use, and is provided only for exceptional situations such as recovering from errors or mistakes, or when Terraform specifically suggests to use
│ it as part of an error message.
╵
╷
│ Error: Get "http://localhost/api/v1/namespaces/kube-system/serviceaccounts/aws-load-balancer-controller-sa": dial tcp [::1]:80: connect: connection refused
│
│   with module.kubernetes_addons.module.aws_load_balancer_controller[0].module.helm_addon.module.irsa[0].kubernetes_service_account_v1.irsa[0],
│   on .terraform/modules/kubernetes_addons/modules/irsa/main.tf line 30, in resource "kubernetes_service_account_v1" "irsa":
│   30: resource "kubernetes_service_account_v1" "irsa" {
│
╵
╷
│ Error: Kubernetes cluster unreachable: invalid configuration: no configuration has been provided, try setting KUBERNETES_MASTER environment variable
│
│   with module.kubernetes_addons.module.metrics_server[0].module.helm_addon.helm_release.addon[0],
│   on .terraform/modules/kubernetes_addons/modules/kubernetes-addons/helm-addon/main.tf line 1, in resource "helm_release" "addon":
│    1: resource "helm_release" "addon" {
│
╵
╷
│ Error: Get "http://localhost/api/v1/namespaces/kube-prometheus-stack": dial tcp [::1]:80: connect: connection refused
│
│   with module.kubernetes_addons.module.kube_prometheus_stack[0].kubernetes_namespace_v1.prometheus,
│   on .terraform/modules/kubernetes_addons/modules/kubernetes-addons/kube-prometheus-stack/main.tf line 6, in resource "kubernetes_namespace_v1" "prometheus":
│    6: resource "kubernetes_namespace_v1" "prometheus" {
│
╵
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$










- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!
- Removido trecho sobre SG adicional para CLUSTER, daí o erro cessou!












module.kubernetes_addons.module.kube_prometheus_stack[0].kubernetes_namespace_v1.prometheus: Still destroying... [id=kube-prometheus-stack, 10s elapsed]
module.kubernetes_addons.module.kube_prometheus_stack[0].kubernetes_namespace_v1.prometheus: Destruction complete after 13s
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

Destroy complete! Resources: 13 destroyed.
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$






terraform destroy -target=module.kubernetes_addons -auto-approve
terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve



- SACAR FORA

~~~~t

  # Configurações do módulo
  create_node_security_group           = true
  node_security_group_name             = "my-eks-node-security-group"
  node_security_group_use_name_prefix  = false
  node_security_group_description      = "My EKS Node Security Group"
  node_security_group_additional_rules = {
    # Exemplo de regra de ingresso
    ingress_example = {
      type        = "ingress"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Exemplo de regra de egresso
    egress_example = {
      type        = "egress"
      from_port   = 30093
      to_port     = 30093
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  node_security_group_tags = {
    Terraform   = "true"
    Environment = "dev"
  }
~~~~



terraform destroy -target=module.kubernetes_addons -auto-approve
terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve



## PENDENTE
- Ajustar SG das EC2 do node-group via manifesto do EKS-BLUEPRINT. Liberar porta 30090, por exemplo, para que o Prometheus fique acessivel de fora.
testar outra maneira, pois usando o "create_node_security_group", ele não aplica a SG parece. Avaliar teste usando a "create_cluster_security_group"
- KB sobre usar parametros dos modulos usados no Blueprint, hierarquias, etc:
https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/main.tf
- Criar KB, sobre como ajustar o Helm do "kube-prometheus-stack" via EKS-BLUEPRINT.










# Dia 22/04/2023

terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks_blueprints -auto-approve
terraform apply -target=module.kubernetes_addons -auto-approve
terraform apply -auto-approve


configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-0e331d7101e87f8ac"

- Verificar Terraform State
Security groups

sg-0c65f0e404d7d89d6 (eks-cluster-sg-eks-lab-1680437171)


- No state está assim:

~~~~json
    {
      "module": "module.eks_blueprints.module.aws_eks",
      "mode": "managed",
      "type": "aws_ec2_tag",
      "name": "cluster_primary_security_group",
      "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
      "instances": [
        {
          "index_key": "Blueprint",
          "schema_version": 0,
          "attributes": {
            "id": "sg-0c65f0e404d7d89d6,Blueprint",
            "key": "Blueprint",
            "resource_id": "sg-0c65f0e404d7d89d6",
            "value": "eks-lab"
          },

[...]

            "vpc_config": [
              {
                "cluster_security_group_id": "sg-0c65f0e404d7d89d6",
                "endpoint_private_access": false,
                "endpoint_public_access": true,
                "public_access_cidrs": [
                  "0.0.0.0/0"
                ],
                "security_group_ids": [
                  "sg-05c5ade1cc25b89cb"
                ],
                "subnet_ids": [
                  "subnet-04de967dfccdc151d",
                  "subnet-0e47796081566a46a",
                  "subnet-0fdcf34f161b1b7ff"
                ],
                "vpc_id": "vpc-0e331d7101e87f8ac"
              }
~~~~




- No apply foi assim

module.eks_blueprints.module.aws_eks.aws_ec2_tag.cluster_primary_security_group["Blueprint"]: Creation complete after 1s [id=sg-0c65f0e404d7d89d6,Blueprint]
module.eks_blueprints.module.aws_eks.aws_ec2_tag.cluster_primary_security_group["GithubRepo"]: Creation complete after 1s [id=sg-0c65f0e404d7d89d6,GithubRepo]
module.eks_blueprints.module.aws_eks.aws_ec2_tag.cluster_primary_security_group["Blueprint"]: Refreshing state... [id=sg-0c65f0e404d7d89d6,Blueprint]
module.eks_blueprints.module.aws_eks.aws_ec2_tag.cluster_primary_security_group["GithubRepo"]: Refreshing state... [id=sg-0c65f0e404d7d89d6,GithubRepo]
module.eks_blueprints.module.aws_eks.aws_ec2_tag.cluster_primary_security_group["GithubRepo"]: Refreshing state... [id=sg-0c65f0e404d7d89d6,GithubRepo]
module.eks_blueprints.module.aws_eks.aws_ec2_tag.cluster_primary_security_group["Blueprint"]: Refreshing state... [id=sg-0c65f0e404d7d89d6,Blueprint]

cluster_primary_security_group


- Na console do EKS
Cluster security group
Info
sg-0c65f0e404d7d89d6 








- Testar

- Exemplo para SG de Cluster:

~~~~t
# Configurações do módulo
  create_cluster_security_group           = true
  cluster_security_group_id               = "my-eks-cluster-security-group"
  cluster_security_group_name             = "my-eks-cluster-security-group"
  cluster_security_group_use_name_prefix  = false
  cluster_security_group_description      = "My EKS Cluster Security Group"
  cluster_additional_security_group_ids   = [aws_security_group.sg.id]
  cluster_security_group_additional_rules = {
    # Exemplo de regra de ingresso
    ingress_example = {
      type        = "ingress"
      from_port   = 8082
      to_port     = 8082
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Exemplo de regra de egresso
    egress_example = {
      type        = "egress"
      from_port   = 30094
      to_port     = 30094
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  cluster_security_group_tags = {
    Terraform   = "true"
    Environment = "dev"
  }
~~~~







Aqui está o código Terraform modificado para permitir o tráfego de qualquer origem nas regras de ingresso e egresso:

~~~~t

cluster_security_group_additional_rules = {
  # Exemplo de regra de ingresso
  ingress_example = {
    type        = "ingress"
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  # Exemplo de regra de egresso
  egress_example = {
    type        = "egress"
    from_port   = 30094
    to_port     = 30094
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  # Regra de ingresso permitindo qualquer origem
  ingress_any = {
    type        = "ingress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  },
  # Regra de egresso permitindo qualquer destino
  egress_any = {
    type        = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
~~~~

Note que foram adicionadas duas novas regras, uma para ingresso e outra para egresso, com os portos configurados como 0 e o protocolo como "-1", o que permite qualquer origem/destino. As regras originais de ingresso e egresso continuam presentes no código para permitir o tráfego nas portas específicas que foram configuradas.




- Editado

~~~~t
  # Configurações do módulo
  create_cluster_security_group           = true
  cluster_security_group_id               = "my-eks-cluster-security-group"
  cluster_security_group_name             = "my-eks-cluster-security-group"
  cluster_security_group_use_name_prefix  = false
  cluster_security_group_description      = "My EKS Cluster Security Group"
  cluster_additional_security_group_ids   = [aws_security_group.sg_adicional.id]

  cluster_security_group_additional_rules = {
    # Exemplo de regra de ingresso
    ingress_example = {
      type        = "ingress"
      from_port   = 8082
      to_port     = 8082
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Exemplo de regra de egresso
    egress_example = {
      type        = "egress"
      from_port   = 30094
      to_port     = 30094
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Regra de ingresso permitindo qualquer origem
    ingress_any = {
      type        = "ingress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Regra de egresso permitindo qualquer destino
    egress_any = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  cluster_security_group_tags = {
    Terraform   = "true"
    Environment = "dev"
    Personalizado = "sim"
  }
~~~~








- Ao adicionar o bloco sobre SG do cluster "cluster_security_group", voltam os erros de "dial tcp [::1]:80: connect: connection refused":

~~~~bash

│ Error: Get "http://localhost/api/v1/namespaces/kube-system/configmaps/aws-auth": dial tcp [::1]:80: connect: connection refused
│
│   with module.eks_blueprints.kubernetes_config_map.aws_auth[0],
│   on .terraform/modules/eks_blueprints/aws-auth-configmap.tf line 1, in resource "kubernetes_config_map" "aws_auth":
│    1: resource "kubernetes_config_map" "aws_auth" {
│

~~~~



- Removidas as configurações do main.tf



terraform destroy -target=module.kubernetes_addons -auto-approve
terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve





## PENDENTE
- Ajustar SG das EC2 do node-group via manifesto do EKS-BLUEPRINT. Liberar porta 30090, por exemplo, para que o Prometheus fique acessivel de fora.
testar outra maneira, pois usando o "create_node_security_group", ele não aplica a SG parece.   teste usando a "create_cluster_security_group" dá erro porta 80 dial.
- Explicação, talvez nao role:
https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1542
- Avaliar add aditional sg!!!!
- KB sobre usar parametros dos modulos usados no Blueprint, hierarquias, etc:
https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/main.tf
- Criar KB, sobre como ajustar o Helm do "kube-prometheus-stack" via EKS-BLUEPRINT.











# Dia 29/04/2023


terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks_blueprints -auto-approve
terraform apply -target=module.kubernetes_addons -auto-approve
terraform apply -auto-approve


configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-0e275861788374089"

configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name eks-lab"
vpc_id = "vpc-0e275861788374089"




~~~~bash
fernando@debian10x64:~$ kubectl get svc -A
NAMESPACE               NAME                                             TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                        AGE
default                 kubernetes                                       ClusterIP   172.20.0.1       <none>        443/TCP                        15m
kube-prometheus-stack   alertmanager-operated                            ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP     4m45s
kube-prometheus-stack   kube-prometheus-stack-alertmanager               ClusterIP   172.20.150.63    <none>        9093/TCP                       4m50s
kube-prometheus-stack   kube-prometheus-stack-grafana                    ClusterIP   172.20.186.28    <none>        80/TCP                         4m50s
kube-prometheus-stack   kube-prometheus-stack-kube-state-metrics         ClusterIP   172.20.77.102    <none>        8080/TCP                       4m50s
kube-prometheus-stack   kube-prometheus-stack-operator                   ClusterIP   172.20.35.89     <none>        443/TCP                        4m50s
kube-prometheus-stack   kube-prometheus-stack-prometheus                 NodePort    172.20.92.107    <none>        9090:30090/TCP                 4m50s
kube-prometheus-stack   kube-prometheus-stack-prometheus-node-exporter   ClusterIP   172.20.166.158   <none>        9100/TCP                       4m50s
kube-prometheus-stack   prometheus-operated                              ClusterIP   None             <none>        9090/TCP                       4m45s
kube-system             aws-load-balancer-webhook-service                ClusterIP   172.20.94.15     <none>        443/TCP                        6m15s
kube-system             kube-dns                                         ClusterIP   172.20.0.10      <none>        53/UDP,53/TCP                  15m
kube-system             kube-prometheus-stack-coredns                    ClusterIP   None             <none>        9153/TCP                       4m50s
kube-system             kube-prometheus-stack-kube-proxy                 ClusterIP   None             <none>        10249/TCP                      4m50s
kube-system             kube-prometheus-stack-kubelet                    ClusterIP   None             <none>        10250/TCP,10255/TCP,4194/TCP   4m45s
kube-system             metrics-server                                   ClusterIP   172.20.184.251   <none>        443/TCP                        6m44s
fernando@debian10x64:~$


fernando@debian10x64:~$ kubectl get nodes -o wide
NAME                         STATUS   ROLES    AGE   VERSION                INTERNAL-IP   EXTERNAL-IP      OS-IMAGE         KERNEL-VERSION                 CONTAINER-RUNTIME
ip-10-0-0-54.ec2.internal    Ready    <none>   11m   v1.23.17-eks-a59e1f0   10.0.0.54     44.200.210.199   Amazon Linux 2   5.4.238-148.347.amzn2.x86_64   docker://20.10.17
ip-10-0-1-157.ec2.internal   Ready    <none>   11m   v1.23.17-eks-a59e1f0   10.0.1.157    52.91.211.29     Amazon Linux 2   5.4.238-148.347.amzn2.x86_64   docker://20.10.17
ip-10-0-2-143.ec2.internal   Ready    <none>   11m   v1.23.17-eks-a59e1f0   10.0.2.143    3.80.215.98      Amazon Linux 2   5.4.238-148.347.amzn2.x86_64   docker://20.10.17
fernando@debian10x64:~$

~~~~



44.200.210.199:30090
















# Grafana Dashboards

-  Adicionando Grafana Dashboards
Projeto: https://github.com/dotdc/grafana-dashboards-kubernetes
Artigo: https://medium.com/@dotdc/a-set-of-modern-grafana-dashboards-for-kubernetes-4b989c72a4b2

- Editado o Values abaixo:
eks-via-terraform-github-actions/09-eks-blueprint/values-stack.yaml


- Adicionado o trecho:

~~~~YAML

# Adicionando Grafana Dashboards
# Projeto: https://github.com/dotdc/grafana-dashboards-kubernetes
# Artigo: https://medium.com/@dotdc/a-set-of-modern-grafana-dashboards-for-kubernetes-4b989c72a4b2

grafana:
  # Provision grafana-dashboards-kubernetes
  dashboardProviders:
    dashboardproviders.yaml:
      apiVersion: 1
      providers:
      - name: 'grafana-dashboards-kubernetes'
        orgId: 1
        folder: 'Kubernetes'
        type: file
        disableDeletion: true
        editable: true
        options:
          path: /var/lib/grafana/dashboards/grafana-dashboards-kubernetes
  dashboards:
    grafana-dashboards-kubernetes:
      k8s-system-api-server:
        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-system-api-server.json
        token: ''
      k8s-system-coredns:
        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-system-coredns.json
        token: ''
      k8s-views-global:
        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-global.json
        token: ''
      k8s-views-namespaces:
        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-namespaces.json
        token: ''
      k8s-views-nodes:
        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-nodes.json
        token: ''
      k8s-views-pods:
        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-pods.json
        token: ''

~~~~


- Efetuando plan:

~~~~bash

module.kubernetes_addons.module.aws_load_balancer_controller[0].module.helm_addon.helm_release.addon[0]: Refreshing state... [id=aws-load-balancer-controller]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # module.kubernetes_addons.module.kube_prometheus_stack[0].module.helm_addon.helm_release.addon[0] will be updated in-place
  ~ resource "helm_release" "addon" {
        id                         = "kube-prometheus-stack"
        name                       = "kube-prometheus-stack"
      ~ values                     = [
          - <<-EOT
                defaultRules:
                  create: true
                  rules:
                    etcd: false
                    kubeScheduler: false
                kubeControllerManager:
                  enabled: false
                kubeEtcd:
                  enabled: false
                kubeScheduler:
                  enabled: false
                prometheus:
                  prometheusSpec:
                    storageSpec:
                      volumeClaimTemplate:
                        spec:
                          accessModes:
                          - ReadWriteOnce
                          resources:
                            requests:
                              storage: 20Gi
                          storageClassName: gp2
                  enabled: true
                  ## Configuration for Prometheus service
                  ##
                  service:
                    annotations: {}
                    labels: {}
                    clusterIP: ""
                    port: 9090
                    ## To be used with a proxy extraContainer port
                    targetPort: 9090
                    ## List of IP addresses at which the Prometheus server service is available
                    ## Ref: https://kubernetes.io/docs/user-guide/services/#external-ips
                    ##
                    externalIPs: []
                    ## Port to expose on each node
                    ## Only used if service.type is 'NodePort'
                    ##
                    nodePort: 30090
                    type: NodePort
            EOT,
          + <<-EOT
                defaultRules:
                  create: true
                  rules:
                    etcd: false
                    kubeScheduler: false
                kubeControllerManager:
                  enabled: false
                kubeEtcd:
                  enabled: false
                kubeScheduler:
                  enabled: false
                prometheus:
                  prometheusSpec:
                    storageSpec:
                      volumeClaimTemplate:
                        spec:
                          accessModes:
                          - ReadWriteOnce
                          resources:
                            requests:
                              storage: 20Gi
                          storageClassName: gp2
                  enabled: true
                  ## Configuration for Prometheus service
                  ##
                  service:
                    annotations: {}
                    labels: {}
                    clusterIP: ""
                    port: 9090
                    ## To be used with a proxy extraContainer port
                    targetPort: 9090
                    ## List of IP addresses at which the Prometheus server service is available
                    ## Ref: https://kubernetes.io/docs/user-guide/services/#external-ips
                    ##
                    externalIPs: []
                    ## Port to expose on each node
                    ## Only used if service.type is 'NodePort'
                    ##
                    nodePort: 30090
                    type: NodePort


                # Adicionando Grafana Dashboards
                # Projeto: https://github.com/dotdc/grafana-dashboards-kubernetes
                # Artigo: https://medium.com/@dotdc/a-set-of-modern-grafana-dashboards-for-kubernetes-4b989c72a4b2

                grafana:
                  # Provision grafana-dashboards-kubernetes
                  dashboardProviders:
                    dashboardproviders.yaml:
                      apiVersion: 1
                      providers:
                      - name: 'grafana-dashboards-kubernetes'
                        orgId: 1
                        folder: 'Kubernetes'
                        type: file
                        disableDeletion: true
                        editable: true
                        options:
                          path: /var/lib/grafana/dashboards/grafana-dashboards-kubernetes
                  dashboards:
                    grafana-dashboards-kubernetes:
                      k8s-system-api-server:
                        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-system-api-server.json
                        token: ''
                      k8s-system-coredns:
                        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-system-coredns.json
                        token: ''
                      k8s-views-global:
                        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-global.json
                        token: ''
                      k8s-views-namespaces:
                        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-namespaces.json
                        token: ''
                      k8s-views-nodes:
                        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-nodes.json
                        token: ''
                      k8s-views-pods:
                        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-pods.json
                        token: ''
            EOT,
        ]
        # (28 unchanged attributes hidden)

        # (1 unchanged block hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$
fernando@debian10x64:~/cursos/terraform/eks-via-terraform-github-actions/09-eks-blueprint$

~~~~





- Aplicando:
terraform apply -auto-approve






- Deu erro
http://192.168.0.110:8080/

dashboards não carregam





- Verificando documentação, tem alguns detalhes

Installation

In most installation cases, you will need to clone this repository (or your fork):

git clone https://github.com/dotdc/grafana-dashboards-kubernetes.git
cd grafana-dashboards-kubernetes

If you plan to deploy these dashboards using ArgoCD, ConfigMaps or Terraform, you will also need to enable and configure the dashboards sidecar on the Grafana Helm chart to get the dashboards loaded in your Grafana instance:

# kube-prometheus-stack values
grafana:
  sidecar:
    dashboards:
      enabled: true
      defaultFolderName: "General"
      label: grafana_dashboard
      labelValue: "1"
      folderAnnotation: grafana_folder
      searchNamespace: ALL
      provider:
        foldersFromFilesStructure: true




- Editando values novamente


- Acessando
http://192.168.0.110:8080/d/k8s_views_global/kubernetes-views-global?orgId=1&refresh=30s
funcionou agora






## Grafana Dashboards

- Adicionados diversos dashboards úteis ao Grafana, que ajudam no gerenciamento dos clusters Kubernetes.
- São adicionados via Helm, conforme tutorial:
eks-via-terraform-github-actions/09-eks-blueprint/material-de-apoio/Grafana-Dashboards-adicionais.md
- Detalhamento de cada Dashboard e o que oferecem, detalhado no artigo abaixo:
<https://medium.com/@dotdc/a-set-of-modern-grafana-dashboards-for-kubernetes-4b989c72a4b2>










# TSHOOT - SG adicional nos Nodes

- Teste adicionando:
  worker_additional_security_group_ids = [aws_security_group.sg_adicional.id]

- Aplicado:

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.



- Não tem efeito, nada ocorre e SG não é adicionada.








terraform destroy -target=module.kubernetes_addons -auto-approve
terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve










## Dia 24/06/2023



- COMANDOS
terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks_blueprints -auto-approve
terraform apply -target=module.kubernetes_addons -auto-approve
terraform apply -auto-approve


# Subindo o projeto

## Permissões

- Para o acesso ao Prometheus ocorrer corretamente via navegador, é necessário liberar a porta 30090 do NodePort na SG da EC2 do EKS.
nodePort: 30090

- Ao liberar a porta na SG que atende as EC2 do node-group, ela fica acessível via navegador, por exemplo:
44.200.210.199:30090
http://44.200.210.199:30090/alerts?search=
<http://44.200.210.199:30090/alerts?search=>

- Até o momento, não foi encontrada maneira de liberar os ips e portas das SG das EC2 dos node-group via Terraform.


- IPs atuais

~~~~bash
fernando@debian10x64:~$ kubectl get nodes -o wide
NAME                         STATUS   ROLES    AGE   VERSION                INTERNAL-IP   EXTERNAL-IP      OS-IMAGE         KERNEL-VERSION                 CONTAINER-RUNTIME
ip-10-0-0-151.ec2.internal   Ready    <none>   29m   v1.23.17-eks-0a21954   10.0.0.151    34.236.243.93    Amazon Linux 2   5.4.242-156.349.amzn2.x86_64   docker://20.10.23
ip-10-0-1-24.ec2.internal    Ready    <none>   29m   v1.23.17-eks-0a21954   10.0.1.24     34.226.249.163   Amazon Linux 2   5.4.242-156.349.amzn2.x86_64   docker://20.10.23
ip-10-0-2-103.ec2.internal   Ready    <none>   29m   v1.23.17-eks-0a21954   10.0.2.103    54.164.139.147   Amazon Linux 2   5.4.242-156.349.amzn2.x86_64   docker://20.10.23
fernando@debian10x64:~$ date
Sat 24 Jun 2023 08:34:22 PM -03
fernando@debian10x64:~$

~~~~


- Acessível, após liberar meu ip na sg:
34.236.243.93:30090



- Terminate

terraform destroy -target=module.kubernetes_addons -auto-approve
terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve









# ####################################################################################################################################################
# ####################################################################################################################################################
# ####################################################################################################################################################
# ####################################################################################################################################################
# ####################################################################################################################################################
### Dia 01/07/2023

- COMANDOS
terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks_blueprints -auto-approve
terraform apply -target=module.kubernetes_addons -auto-approve
terraform apply -auto-approve


# Subindo o projeto

## Permissões

- Para o acesso ao Prometheus ocorrer corretamente via navegador, é necessário liberar a porta 30090 do NodePort na SG da EC2 do EKS.
nodePort: 30090

- Ao liberar a porta na SG que atende as EC2 do node-group, ela fica acessível via navegador, por exemplo:
44.200.210.199:30090
http://44.200.210.199:30090/alerts?search=
<http://44.200.210.199:30090/alerts?search=>

- Até o momento, não foi encontrada maneira de liberar os ips e portas das SG das EC2 dos node-group via Terraform.


- IPs atuais

~~~~bash
fernando@debian10x64:~$ kubectl get nodes -o wide

fernando@debian10x64:~$ kubectl get nodes -o wide
NAME                         STATUS   ROLES    AGE     VERSION                INTERNAL-IP   EXTERNAL-IP     OS-IMAGE         KERNEL-VERSION                 CONTAINER-RUNTIME
ip-10-0-0-41.ec2.internal    Ready    <none>   3h13m   v1.23.17-eks-0a21954   10.0.0.41     44.204.116.87   Amazon Linux 2   5.4.242-156.349.amzn2.x86_64   docker://20.10.23
ip-10-0-1-72.ec2.internal    Ready    <none>   3h13m   v1.23.17-eks-0a21954   10.0.1.72     44.204.12.241   Amazon Linux 2   5.4.242-156.349.amzn2.x86_64   docker://20.10.23
ip-10-0-2-124.ec2.internal   Ready    <none>   3h13m   v1.23.17-eks-0a21954   10.0.2.124    3.80.70.254     Amazon Linux 2   5.4.242-156.349.amzn2.x86_64   docker://20.10.23
fernando@debian10x64:~$ date
Sat 01 Jul 2023 11:31:37 PM -03
fernando@debian10x64:~$

~~~~




- DESTROY

terraform destroy -target=module.kubernetes_addons -auto-approve
terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve








# ####################################################################################################################################################
# ####################################################################################################################################################
# ####################################################################################################################################################
# ####################################################################################################################################################
# ####################################################################################################################################################
##  PENDENTE

- Ajustar SG das EC2 do node-group via manifesto do EKS-BLUEPRINT. Liberar porta 30090, por exemplo, para que o Prometheus fique acessivel de fora.
testar outra maneira, pois usando o "create_node_security_group", ele não aplica a SG parece.   teste usando a "create_cluster_security_group" dá erro porta 80 dial.
- Explicação, talvez nao role:
https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1542
- Efetuar tshoot com base na resposta:
https://medium.com/@fernandomllerjr/hi-6ec6fd207f0b
https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/variables.tf#L314
- Avaliar add aditional sg!!!!
- KB sobre usar parametros dos modulos usados no Blueprint, hierarquias, etc:
https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/main.tf
- Criar KB, sobre como ajustar o Helm do "kube-prometheus-stack" via EKS-BLUEPRINT.







