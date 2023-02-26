# eks-via-terraform-github-actions

Projeto que efetua o deploy de um cluster EKS usando o Terraform.
Contendo opção que faz o deploy através de uma Pipeline no Github Actions.




git status
git add .
git commit -m "Projeto - eks-via-terraform-github-actions"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status