

# LAB 09 - EKS via Blueprint + Prometheus + Grafana + AlertManager - Sem Github Actions

## Descrição
Projeto que cria um Cluster EKS via Terraform, usando Blueprint do EKS.<br/>
Já efetua a criação da estrutura de RBAC (ClusterRole, ClusterRoleBinding, ClusterRole), aplicando os devidos manifestos.<br/>
Também adiciona 2 usuários(usuário root e um usuário comum) como administradores, fazendo uso do "Teams", que é um recurso que facilita a criação de acesso ao cluster.<br/>
Efetuada instalação da stack kube-prometheus-stack, contendo:<br/>
Prometheus<br/>
Grafana<br/>
AlertManager<br/>
<br/><br/>

## Blueprint
Blueprint utilizado como referência:<br/>
<https://catalog.workshops.aws/eks-blueprints-terraform/en-US><br/>

## Teams
Um pouco mais sobre o Teams:<br/>
<https://aws-ia.github.io/terraform-aws-eks-blueprints/teams/><br/>

