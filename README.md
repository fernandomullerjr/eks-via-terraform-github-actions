
<h1 align="center"> Projetos em EKS via Terraform </h1>

![Amazon EKS + Terraform](https://github.com/fernandomullerjr/eks-via-terraform-github-actions/blob/main/outros-materiais/imagens/amazon-eks-plus-terraform.png?raw=true)


## Descrição do projeto 

<p align="justify">
  Coleção de projetos que efetuam o deploy de um cluster EKS usando o Terraform.<br/>
  Idéia deste repositório é fornecer manifestos testados e validados, contendo alguns cenários de clusters EKS que podemos precisar.<br/>
  Alguns projetos vão utilizar Blueprints, outros terão os manifestos separados, alguns terão uma pipeline que efetua o deploy dependendo da ação e a trigger.<br/>
</p>


## :hammer: Projetos - EKS + Terraform

[Lab07 - EKS via Blueprint + RBAC - Sem Github Actions](07-eks-blueprint/README.md)
<details> 
  <summary><b>Detalhes sobre o projeto</b> <em>(clique para visualizar)</em></summary>
Projeto que cria um Cluster EKS via Terraform, usando Blueprint do EKS.<br/>
Já efetua a criação da estrutura de RBAC (ClusterRole, ClusterRoleBinding, ClusterRole), aplicando os devidos manifestos.<br/>
Também adiciona 2 usuários(usuário root e um usuário comum) como administradores, fazendo uso do "Teams", que é um recurso que facilita a criação de acesso ao cluster.<br/>
</details>


[Lab09 - EKS via Blueprint + RBAC + Stack do Prometheus - Sem Github Actions](09-eks-blueprint/README.md)
<details> 
  <summary><b>Detalhes sobre o projeto</b> <em>(clique para visualizar)</em></summary>
Projeto que cria um Cluster EKS via Terraform, usando Blueprint do EKS.<br/>
Já efetua a criação da estrutura de RBAC (ClusterRole, ClusterRoleBinding, ClusterRole), aplicando os devidos manifestos.<br/>
Também adiciona 2 usuários(usuário root e um usuário comum) como administradores, fazendo uso do "Teams", que é um recurso que facilita a criação de acesso ao cluster.<br/>
Efetua a instalação da stack kube-prometheus-stack, contendo:<br/>
Prometheus<br/>
Grafana<br/>
AlertManager<br/>
<br/><br/>
</details>


> Status do Projeto: :warning: (em desenvolvimento, em breve serão adicionados novos projetos de exemplo)