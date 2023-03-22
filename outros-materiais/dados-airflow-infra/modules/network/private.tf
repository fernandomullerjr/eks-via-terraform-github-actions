resource "aws_subnet" "vpc-virgina-3-subnet-privada-3" {
    vpc_id = data.aws_vpc.vpc-virginia-3.id
    cidr_block = "172.17.7.0/24"

    availability_zone = format("%sa", var.aws_region)

    tags = {
        Name = format("%s-private-1a", var.cluster_name)
        Squad = "DadosN2"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
        "Billing" = "dados"
    }
}

resource "aws_subnet" "vpc-virgina-3-subnet-privada-4" {
    vpc_id = data.aws_vpc.vpc-virginia-3.id
    cidr_block = "172.17.8.0/24"

    availability_zone = format("%sc", var.aws_region)

    tags = {
        Name = format("%s-private-1c", var.cluster_name)
        Squad = "DadosN2"
        "Billing" = "dados"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}

resource "aws_route_table_association" "vpc-virgina-3-subnet-privada-3" {
  subnet_id = aws_subnet.vpc-virgina-3-subnet-privada-3.id
  route_table_id = aws_route_table.nat.id
}

resource "aws_route_table_association" "vpc-virgina-3-subnet-privada-4" {
  subnet_id = aws_subnet.vpc-virgina-3-subnet-privada-4.id
  route_table_id = aws_route_table.nat.id
}