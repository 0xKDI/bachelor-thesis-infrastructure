locals {
  tags = merge(var.tags, { Terraform_module = "subnet" })
}


resource "aws_subnet" "default" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  map_public_ip_on_launch = var.public
}


resource "aws_route_table_association" "default_route_table" {
  subnet_id      = aws_subnet.default.id
  route_table_id = var.route_table_id
}

