resource "aws_subnet" "PubLB1" {
  vpc_id     = var.VPCDevOpsRampUp
  availability_zone = var.AZ_A
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "PubLB1"
  }
}

resource "aws_subnet" "PubLB2" {
  vpc_id     = var.VPCDevOpsRampUp
  availability_zone = var.AZ_B
  cidr_block = "10.1.2.0/24"

  tags = {
    Name = "PubLB2"
  }
}

resource "aws_subnet" "PriFE1" {
  vpc_id     = var.VPCDevOpsRampUp
  availability_zone = var.AZ_A
  cidr_block = "10.1.3.0/24"

  tags = {
    Name = "PriFE1"
  }
}

resource "aws_subnet" "PriFE2" {
  vpc_id     = var.VPCDevOpsRampUp
  availability_zone = var.AZ_B
  cidr_block = "10.1.4.0/24"

  tags = {
    Name = "PriFE2"
  }
}

resource "aws_subnet" "PriBE1" {
  vpc_id     = var.VPCDevOpsRampUp
  availability_zone = var.AZ_A
  cidr_block = "10.1.5.0/24"

  tags = {
    Name = "PriBE1"
  }
}

resource "aws_subnet" "PriBE2" {
  vpc_id     = var.VPCDevOpsRampUp
  availability_zone = var.AZ_B
  cidr_block = "10.1.6.0/24"

  tags = {
    Name = "PriBE2"
  }
}



resource "aws_eip" "nat_gateway_ip" {
}

resource "aws_nat_gateway" "NATGW" {
  allocation_id = aws_eip.nat_gateway_ip.id
  subnet_id     = aws_subnet.PubLB1.id
  tags = {
    Name = "NATGW"
  }


}





resource "aws_route_table" "PubRTBastion" {
  vpc_id = var.VPCDevOpsRampUp
  tags = {
    Name = "PubRTBastion"
  }
}

resource "aws_route_table" "PriRTFE" {
  vpc_id = var.VPCDevOpsRampUp
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATGW.id
  }

  tags = {
    Name = "PriRTFE"
  }
}

resource "aws_route_table" "PriRTBE" {
  vpc_id = var.VPCDevOpsRampUp
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATGW.id
  }
  tags = {
    Name = "PriRTBE"
  }
}

resource "aws_route_table" "PubRT" {
  vpc_id = var.VPCDevOpsRampUp

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.IGW
  }

  tags = {
    Name = "PubRT"
  }
}

resource "aws_route_table_association" "RTA_PubLB1" {
  subnet_id      = aws_subnet.PubLB1.id
  route_table_id = aws_route_table.PubRT.id
}
resource "aws_route_table_association" "RTA_PubLB2" {
  subnet_id      = aws_subnet.PubLB2.id
  route_table_id = aws_route_table.PubRT.id
}

resource "aws_route_table_association" "RTA_PriFE1" {
  subnet_id      = aws_subnet.PriFE1.id
  route_table_id = aws_route_table.PriRTFE.id
}
resource "aws_route_table_association" "RTA_PriFE2" {
  subnet_id      = aws_subnet.PriFE2.id
  route_table_id = aws_route_table.PriRTFE.id
}

resource "aws_route_table_association" "RTA_PriBE1" {
  subnet_id      = aws_subnet.PriBE1.id
  route_table_id = aws_route_table.PriRTBE.id
}
resource "aws_route_table_association" "RTA_PriBE2" {
  subnet_id      = aws_subnet.PriBE2.id
  route_table_id = aws_route_table.PriRTBE.id
}