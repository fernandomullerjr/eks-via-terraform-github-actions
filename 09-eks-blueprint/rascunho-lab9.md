

# 09-eks-lab

- Projeto usando eks-blueprint
https://catalog.workshops.aws/eks-blueprints-terraform/en-US/030-provision-eks-cluster/1-create-a-terraform-project



# RESUMO

- COMANDOS
terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks_blueprints -auto-approve
terraform apply -target=module.kubernetes_addons -auto-approve
terraform apply -auto-approve

terraform destroy -target=module.kubernetes_addons -auto-approve
terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -target=module.vpc -auto-approve
terraform destroy -auto-approve



# SOLUÇÃO
- Para usuários comuns, adicionar o arn do usuário normal.
- Para usuário root, adicionar arn "arn:aws:iam::261106957109:root" ao invés do arn do usuário com nome do usuário.

## Obs
- Seguir o README no Apply e no Destroy.
- Cuidar extensão do nome(no locals.tf), para não formar um nome muito longo ao recurso.


## INFO

- Projeto sobe EKS + Prometheus + Grafana + AlertManager

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





## PENDENTE
- Ajustar SG das EC2 do node-group via manifesto do EKS-BLUEPRINT.
- Criar KB, sobre como ajustar o Helm do "kube-prometheus-stack" via EKS-BLUEPRINT.