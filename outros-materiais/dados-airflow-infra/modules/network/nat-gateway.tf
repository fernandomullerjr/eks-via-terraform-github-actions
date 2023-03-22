resource "aws_eip" "vpc_iep" {
    vpc = true
    tags = {
        Name = format("dados-%s-eip", var.cluster_name)
        Squad = "DadosN2"
        "Billing" = "dados"
    }
}

resource "aws_nat_gateway" "nat" {
    allocation_id   = aws_eip.vpc_iep.id
    subnet_id       = aws_subnet.vpc-virgina-3-subnet-publica-7.id

    tags = {
      Name = format("dados-%s-nat-gateway", var.cluster_name)
      Squad = "DadosN2"
      "Billing" = "dados"
    }  
}

resource "aws_route_table" "nat" {
    vpc_id = data.aws_vpc.vpc-virginia-3.id

    tags = {
        Name = format("dados-%s-private-route", var.cluster_name)
        Squad = "DadosN2"
        "Billing" = "dados"
    }
}

resource "aws_route" "nat_access" {
    route_table_id = aws_route_table.nat.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
}

