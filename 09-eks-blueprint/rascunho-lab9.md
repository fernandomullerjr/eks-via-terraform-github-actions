

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












Get the Prometheus server URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace prometheus -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace prometheus port-forward $POD_NAME 9090
#################################################################################
######   WARNING: Persistence is disabled!!! You will lose your data when   #####
######            the Server pod is terminated.                             #####
#################################################################################






# PENDENTE
- Quando utilizando Persistence, os Pods do Prometheus-Server e do AlertManager não sobem.
Pode ser devido o GP2 e o PVC que eles tentam utilizar.
Tentar aplicar solução, criando o PVC tbm:
https://stackoverflow.com/questions/47235014/why-prometheus-pod-pending-after-setup-it-by-helm-in-kubernetes-cluster-on-ranch
<https://stackoverflow.com/questions/47235014/why-prometheus-pod-pending-after-setup-it-by-helm-in-kubernetes-cluster-on-ranch>