
# Airflow EKS

O Airflow é uma ferramente de orquestraçao e pipelines de dados, que nos prover um workflow de dados mais
resiliente, dinamico, e mais organizado.

O projeto em si é composto por um cluster EKS e o deployment dos serviços do Airflow, toda infraestrutura do EKS
 é criada via Terraform, e os serviços sao criados via Helm. Os componentes do cluster EKS foram separados
 nos seguintes modulos:

 * **Network** - Composto por uma VPC ja existente, 2 subnets publicas, 2 subnets privads, 1 internet gateway e 1 nat gateway
 * **Master** - Composto 1 Node EKS Master, 1 role no IAM, 1 security group
 * **Nodes** - Composto por 1 Node Group,1 role no IAM, 2 policy de auto-scaling, 2 alarmes no cloudwatch para o autoscaling

Já os serviços e configuracoes do Airflow estao todos declarados no arquivo *kubernetes/airflow/values.yml*.






## Requisitos necessarios:

 - [Docker version 20.10.17](https://docs.docker.com/engine/install/ubuntu/)
 - [Docker Compose 2.6.0](https://docs.docker.com/compose/install/)
 - [Terraform v1.2.5](https://learn.hashicorp.com/tutorials/terraform/install-cli)
 - [Helm v3.9.0](https://helm.sh/docs/intro/install/)



## Ambiente de desenvolvimento

Para desenvolver suas DAGs com o mesmo ambiente de produçao, criamos um *docker-compose.yml* para simular o ambiente
localmente. Depois de instalado os requisitos necessarios rode os seguintes comandos:

```bash
  cd kubernetes/airflow
  docker compose build
  docker compose up -d
```

Isso ira subir a stack do airflow juntamente com o webserver na URL http://localhost:8080, como o usuario padrao `airflow`
e a senha `airflow`.

