module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "vpc"

  cidr = var.net_vpc
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
  public_subnets  = ["10.20.4.0/24", "10.20.5.0/24", "10.20.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

data "aws_vpc" "vpc1" {
  id = var.VPCDevOpsRampUp
}

# Crear una conexión de peering desde VPC1 a VPC2
resource "aws_vpc_peering_connection" "peer1_to_peer2" {
  peer_vpc_id = module.vpc.vpc_id
  vpc_id      = var.VPCDevOpsRampUp
  auto_accept = true
}

# Establecer rutas de VPC1 a VPC2
resource "aws_route" "route_to_peer2" {
  route_table_id         = data.aws_vpc.vpc1.main_route_table_id
  destination_cidr_block = var.net_vpc
  vpc_peering_connection_id = aws_vpc_peering_connection.peer1_to_peer2.id
}

# Establecer rutas de VPC2 a VPC1
resource "aws_route" "route_to_peer1" {
  route_table_id         = module.vpc.vpc_main_route_table_id
  destination_cidr_block = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer1_to_peer2.id
}

resource "aws_route" "example_route" {
  route_table_id         = var.rt_bastion
  destination_cidr_block = var.net_vpc
  gateway_id             = aws_vpc_peering_connection.peer1_to_peer2.id
}