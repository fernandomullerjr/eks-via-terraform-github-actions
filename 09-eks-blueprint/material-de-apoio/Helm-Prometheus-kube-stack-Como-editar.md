
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



- O main.tf ficou assim, na parte dos addons:

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




- Meu arquivo values editado:

eks-via-terraform-github-actions/09-eks-blueprint/values-stack.yaml

coloquei a porta do NodePort explicita em 30090 e o service type para NodePort

~~~~YAML
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
~~~~


