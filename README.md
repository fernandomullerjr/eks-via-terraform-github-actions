
<h1 align="center"> Projetos em EKS via Terraform </h1>

![Amazon EKS + Terraform](https://github.com/fernandomullerjr/eks-via-terraform-github-actions/blob/main/outros-materiais/imagens/amazon-eks-plus-terraform.png?raw=true)



### Tópicos 

:small_blue_diamond: [Descrição do projeto](#descrição-do-projeto)

:small_blue_diamond: [:hammer: Lab07 - EKS via Blueprint - Sem Github Actions](#lab07-eks-via-blueprint)

:small_blue_diamond: [Deploy da Aplicação](#deploy-da-aplicação-dash)

:small_blue_diamond: [Pré-requisitos](#pré-requisitos)

:small_blue_diamond: [Como rodar a aplicação](#como-rodar-a-aplicação-arrow_forward)

... 


## Descrição do projeto 

<p align="justify">
  Coleção de projetos que efetuam o deploy de um cluster EKS usando o Terraform.<br/>
  Idéia deste repositório é fornecer manifestos testados e validados, contendo alguns cenários de clusters EKS que podemos precisar.<br/>
  Alguns projetos vão utilizar Blueprints, outros terão os manifestos separados, alguns terão uma pipeline que efetua o deploy dependendo da ação e a trigger.<br/>
</p>


## :hammer: Projetos - EKS + Terraform

- ` 1 EKS via Blueprint - Sem Github Actions`: Projeto que cria um Cluster EKS via Terraform, usando Blueprint do EKS.
Já efetua a criação da estrutura de RBAC (ClusterRole, ClusterRoleBinding, ClusterRole), aplicando os devidos manifestos.
Também adiciona 2 usuários(usuário root e um usuário comum) como administradores, fazendo uso do "Teams", que é um recurso que facilita a criação de acesso ao cluster.
- `Funcionalidade 2`: descrição da funcionalidade 2
- `Funcionalidade 2a`: descrição da funcionalidade 2a relacionada à funcionalidade 2
- `Funcionalidade 3`: descrição da funcionalidade 3



## [:hammer: Lab07 - EKS via Blueprint - Sem Github Actions](07-eks-blueprint/README.md)

<details> 
  <summary><b>1 EKS via Blueprint - Detalhes</b> <em>(clique para visualizar)</em></summary>
Projeto que cria um Cluster EKS via Terraform, usando Blueprint do EKS.<br/>
Já efetua a criação da estrutura de RBAC (ClusterRole, ClusterRoleBinding, ClusterRole), aplicando os devidos manifestos.<br/>
Também adiciona 2 usuários(usuário root e um usuário comum) como administradores, fazendo uso do "Teams", que é um recurso que facilita a criação de acesso ao cluster.<br/>
</details>