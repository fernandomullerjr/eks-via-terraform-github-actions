

# LAB 07 - EKS via Blueprint - Sem Github Actions

Projeto que cria um Cluster EKS via Terraform, usando Blueprint do EKS.<br/>
Já efetua a criação da estrutura de RBAC (ClusterRole, ClusterRoleBinding, ClusterRole), aplicando os devidos manifestos.<br/>
Também adiciona 2 usuários(usuário root e um usuário comum) como administradores, fazendo uso do "Teams", que é um recurso que facilita a criação de acesso ao cluster.<br/>

Blueprint utilizado como referência:<br/>
<https://catalog.workshops.aws/eks-blueprints-terraform/en-US><br/>

Um pouco mais sobre o Teams:<br/>
<https://aws-ia.github.io/terraform-aws-eks-blueprints/teams/><br/>