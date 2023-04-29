
# Tutorial - Grafana Dashboards

- Tutorial que explica como adicionar diversos dashboards úteis ao Grafana, que ajudam no gerenciamento dos clusters Kubernetes.
- Detalhamento de cada Dashboard e o que oferecem, detalhado no artigo abaixo:
<https://medium.com/@dotdc/a-set-of-modern-grafana-dashboards-for-kubernetes-4b989c72a4b2>


# Description

This repository contains a modern set of Grafana dashboards for Kubernetes.
They are inspired by many other dashboards from kubernetes-mixin and grafana.com.

More information about them in my article: A set of modern Grafana dashboards for Kubernetes

You can also download them on Grafana.com.

# Grafana Dashboards - Passo-a-passo

-  Adicionando Grafana Dashboards
Projeto: https://github.com/dotdc/grafana-dashboards-kubernetes
Artigo: https://medium.com/@dotdc/a-set-of-modern-grafana-dashboards-for-kubernetes-4b989c72a4b2

- Editado o Values abaixo:
eks-via-terraform-github-actions/09-eks-blueprint/values-stack.yaml


- Adicionado o trecho:

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


# Adicionando Grafana Dashboards
# Projeto: https://github.com/dotdc/grafana-dashboards-kubernetes
# Artigo: https://medium.com/@dotdc/a-set-of-modern-grafana-dashboards-for-kubernetes-4b989c72a4b2

grafana:
  # Provision grafana-dashboards-kubernetes
  dashboardProviders:
    dashboardproviders.yaml:
      apiVersion: 1
      providers:
      - name: 'grafana-dashboards-kubernetes'
        orgId: 1
        folder: 'Kubernetes'
        type: file
        disableDeletion: true
        editable: true
        options:
          path: /var/lib/grafana/dashboards/grafana-dashboards-kubernetes
  dashboards:
    grafana-dashboards-kubernetes:
      k8s-system-api-server:
        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-system-api-server.json
        token: ''
      k8s-system-coredns:
        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-system-coredns.json
        token: ''
      k8s-views-global:
        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-global.json
        token: ''
      k8s-views-namespaces:
        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-namespaces.json
        token: ''
      k8s-views-nodes:
        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-nodes.json
        token: ''
      k8s-views-pods:
        url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-pods.json
        token: ''
  sidecar:
    dashboards:
      enabled: true
      defaultFolderName: "General"
      label: grafana_dashboard
      labelValue: "1"
      folderAnnotation: grafana_folder
      searchNamespace: ALL
      provider:
        foldersFromFilesStructure: true
~~~~