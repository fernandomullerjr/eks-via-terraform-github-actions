
data "aws_internet_gateway" "gw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.vpc-virginia-3.id]
  }
}

resource "aws_route_table" "igw_route_table" {
    vpc_id = data.aws_vpc.vpc-virginia-3.id

    tags = {
        Name = format("dados-%s-public-route", var.cluster_name)
        Squad = "DadosN2"
        "Billing" = "dados"
    }
}


resource "aws_route" "public_internet_access" {
    route_table_id = aws_route_table.igw_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.gw.id

}
