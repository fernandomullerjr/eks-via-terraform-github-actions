
## Destroy

To teardown and remove the resources created in this example:

First, we need to ensure that the ArgoCD applications are properly cleaned up from the cluster, this can be achieved in multiple ways:

1) Disabling the `argocd_applications` configuration and running `terraform apply` again
2) Deleting the apps using `argocd` [cli](https://argo-cd.readthedocs.io/en/stable/user-guide/app_deletion/#deletion-using-argocd)
3) Deleting the apps using `kubectl` following [ArgoCD guidance](https://argo-cd.readthedocs.io/en/stable/user-guide/app_deletion/#deletion-using-kubectl)

Then you can start delete the terraform resources:
```sh
terraform destroy -target=module.eks_blueprints_kubernetes_addons -auto-approve
terraform destroy -target=module.eks_blueprints -auto-approve
terraform destroy -auto-approve
````










# Deletion Using kubectl¶

To perform a non-cascade delete:

kubectl delete app APPNAME

To perform a cascade delete set the finalizer, e.g. using kubectl patch:

kubectl patch app APPNAME  -p '{"metadata": {"finalizers": ["resources-finalizer.argocd.argoproj.io"]}}' --type merge
kubectl delete app APPNAME

About The Deletion Finalizer¶

metadata:
  finalizers:
    - resources-finalizer.argocd.argoproj.io

When deleting an Application with this finalizer, the Argo CD application controller will perform a cascading delete of the Application's resources.

Adding the finalizer enables cascading deletes when implementing the App of Apps pattern.

When you invoke argocd app delete with --cascade, the finalizer is added automatically.