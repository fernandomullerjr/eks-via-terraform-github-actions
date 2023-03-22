resource "aws_security_group" "cluster_master_sg" {

    name = format("dados-%s-master-sg", var.cluster_name)
    vpc_id = var.cluster_vpc.id

    # Regra de saida
    egress {
        from_port   = 0
        to_port     = 0

        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = format("dados-%s-master-sg", var.cluster_name)
        Squad = "Dados"
        "Billing" = "dados"
    }

}

# Regras de entrada
resource "aws_security_group_rule" "cluster_ingress_airflow_webserver" {
    cidr_blocks = ["23.22.85.107/32","54.232.167.125/32","18.228.146.202/32","172.30.1.63/32"]
    from_port = 8080
    to_port     = 8080
    protocol    = "tcp"

    security_group_id = aws_security_group.cluster_master_sg.id
    type = "ingress"
}
