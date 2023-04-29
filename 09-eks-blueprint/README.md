

# LAB 09 - EKS via Blueprint + Prometheus + Grafana + AlertManager - Sem Github Actions

## Descrição

## EKS
Projeto que cria um Cluster EKS via Terraform, usando Blueprint do EKS.<br/>
Já efetua a criação da estrutura de RBAC (ClusterRole, ClusterRoleBinding, ClusterRole), aplicando os devidos manifestos.<br/>
Também adiciona 2 usuários(usuário root e um usuário comum) como administradores, fazendo uso do "Teams", que é um recurso que facilita a criação de acesso ao cluster.<br/>

## Stack do Prometheus

Efetuada instalação da stack kube-prometheus-stack, contendo:<br/>
Prometheus<br/>
Grafana<br/>
AlertManager<br/>
<br/><br/>

## Grafana Dashboards

- Adicionados diversos dashboards úteis ao Grafana, que ajudam no gerenciamento dos clusters Kubernetes.
- São adicionados via Helm, conforme tutorial:
eks-via-terraform-github-actions/09-eks-blueprint/material-de-apoio/Grafana-Dashboards-adicionais.md
- Detalhamento de cada Dashboard e o que oferecem, detalhado no artigo abaixo:
<https://medium.com/@dotdc/a-set-of-modern-grafana-dashboards-for-kubernetes-4b989c72a4b2>

## Blueprint
Blueprint utilizado como referência:<br/>
<https://catalog.workshops.aws/eks-blueprints-terraform/en-US><br/>

## Teams
Um pouco mais sobre o Teams:<br/>
<https://aws-ia.github.io/terraform-aws-eks-blueprints/teams/><br/>

## kube-prometheus-stack Helm Chart
Stack contendo Prometheus, Grafana e AlertManager
<https://github.com/aws-ia/terraform-aws-eks-blueprints/tree/main/modules/kubernetes-addons/kube-prometheus-stack>

## Security Group personalizada
[EM MANUTENÇÃO]
Adicionado bloco que configura rules adicionais para a Security Group utilizada pelos Nodes.
<https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/main.tf>


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