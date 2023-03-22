resource "aws_eks_node_group" "cluster" {
  
    cluster_name = var.eks_cluster.name
    node_group_name = format("dados-%s-node-group", var.cluster_name)
    node_role_arn = aws_iam_role.eks_nodes_roles.arn

    subnet_ids = [
        var.vpc_subnet_privada_3.id,
        var.vpc_subnet_privada_4.id
    ]

    instance_types = var.nodes_instances_sizes

    scaling_config {
        desired_size    = lookup(var.auto_scale_options, "desired")
        max_size        = lookup(var.auto_scale_options, "max")
        min_size        = lookup(var.auto_scale_options, "min")
    }

    tags = {
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
        Squad = "Dados"
        "Billing" = "dados"
    }

}
