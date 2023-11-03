# Crear una conexión de peering desde VPC1 a VPC2
resource "aws_vpc_peering_connection" "peer1_to_peer2" {
  peer_vpc_id = aws_vpc.kcluster-k8s-local.id
  vpc_id      = var.VPCDevOpsRampUp
  auto_accept = true
}

# Establecer rutas de VPC1 a VPC2
resource "aws_route" "add_route" {
  route_table_id         = var.rt_bastion
  destination_cidr_block = var.net_vpc
  gateway_id             = aws_vpc_peering_connection.peer1_to_peer2.id
}

# Establecer rutas de VPC2 a VPC1

resource "aws_route" "custom_route" {
  route_table_id         = local.route_table_public_id
  destination_cidr_block = "10.1.0.0/16"  # Reemplaza con la CIDR de tu elección
  vpc_peering_connection_id = aws_vpc_peering_connection.peer1_to_peer2.id  # Reemplaza con el ID de tu VPC peering
}