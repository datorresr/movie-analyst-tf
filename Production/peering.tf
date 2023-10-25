provider "aws" {
  region = var.region
}
data "aws_vpc" "vpc1" {
  id = var.VPCDevOpsRampUp
}


resource "aws_vpc" "vpc2" {
  cidr_block = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Crear una conexión de peering desde VPC1 a VPC2
resource "aws_vpc_peering_connection" "peer1_to_peer2" {
  peer_vpc_id = aws_vpc.vpc2.id
  vpc_id      = var.VPCDevOpsRampUp
}

# Aceptar la conexión de peering en VPC2
resource "aws_vpc_peering_connection_accepter" "peer_accepter" {
  provider                  = aws.vpc
  vpc_peering_connection_id  = aws_vpc_peering_connection.peer1_to_peer2.id
}

# Establecer rutas de VPC1 a VPC2
resource "aws_route" "route_to_peer2" {
  route_table_id         = data.aws_vpc.vpc1.main_route_table_id
  destination_cidr_block = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer1_to_peer2.id
}

# Establecer rutas de VPC2 a VPC1
resource "aws_route" "route_to_peer1" {
  route_table_id         = aws_vpc.vpc2.main_route_table_id
  destination_cidr_block = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer1_to_peer2.id
}