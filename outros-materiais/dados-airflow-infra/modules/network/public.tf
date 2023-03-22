resource "aws_subnet" "vpc-virgina-3-subnet-publica-7" {
    vpc_id = data.aws_vpc.vpc-virginia-3.id
    cidr_block = "172.17.9.0/24"

    availability_zone = format("%sa", var.aws_region)

    tags = {
        Name = format("%s-public-1a", var.cluster_name)
        Squad = "DadosN2"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}

resource "aws_subnet" "vpc-virgina-3-subnet-publica-8" {
    vpc_id = data.aws_vpc.vpc-virginia-3.id
    cidr_block = "172.17.10.0/24"

    availability_zone = format("%sc", var.aws_region)

    tags = {
        Name = format("%s-public-1c", var.cluster_name)
        Squad = "DadosN2"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}

resource "aws_route_table_association" "vpc-virgina-3-subnet-publica-7" {
  subnet_id = aws_subnet.vpc-virgina-3-subnet-publica-7.id
  route_table_id = aws_route_table.igw_route_table.id
}

resource "aws_route_table_association" "vpc-virgina-3-subnet-publica-8" {
  subnet_id = aws_subnet.vpc-virgina-3-subnet-publica-8.id
  route_table_id = aws_route_table.igw_route_table.id
}