terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "VPCDevOpsRampUp" {

}
import {
 id = "vpc-0014df68b2375fd8f"
 # Resource address
 to = VPCDevOpsRampUp.this
}




resource "aws_subnet" "PubLB1" {
  vpc_id     = aws_vpc.VPCDevOpsRampUp.id
  availability_zone = "us-east-1a"
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "PubLB1"
  }
}

resource "aws_subnet" "PubLB2" {
  vpc_id     = aws_vpc.VPCDevOpsRampUp.id
  availability_zone = "us-east-1b"
  cidr_block = "10.1.2.0/24"

  tags = {
    Name = "PubLB2"
  }
}

resource "aws_subnet" "PriFE1" {
  vpc_id     = aws_vpc.VPCDevOpsRampUp.id
  availability_zone = "us-east-1a"
  cidr_block = "10.1.3.0/24"

  tags = {
    Name = "PriFE1"
  }
}

resource "aws_subnet" "PriFE2" {
  vpc_id     = aws_vpc.VPCDevOpsRampUp.id
  availability_zone = "us-east-1b"
  cidr_block = "10.1.4.0/24"

  tags = {
    Name = "PriFE2"
  }
}

resource "aws_subnet" "PriBE1" {
  vpc_id     = aws_vpc.VPCDevOpsRampUp.id
  availability_zone = "us-east-1a"
  cidr_block = "10.1.5.0/24"

  tags = {
    Name = "PriBE1"
  }
}

resource "aws_subnet" "PriBE2" {
  vpc_id     = aws_vpc.VPCDevOpsRampUp.id
  availability_zone = "us-east-1b"
  cidr_block = "10.1.6.0/24"

  tags = {
    Name = "PriBE2"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPCDevOpsRampUp.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_eip" "nat_gateway_ip" {
  depends_on = [aws_internet_gateway.IGW]
}

resource "aws_nat_gateway" "NATGW" {
  allocation_id = aws_eip.nat_gateway_ip.id
  subnet_id     = aws_subnet.PubLB1.id
  tags = {
    Name = "NATGW"
  }

  depends_on = [aws_internet_gateway.IGW]

}


resource "aws_route_table" "PriRTFE" {
  vpc_id = aws_vpc.VPCDevOpsRampUp.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATGW.id
  }

  tags = {
    Name = "PriRTFE"
  }
}

resource "aws_route_table" "PriRTBE" {
  vpc_id = aws_vpc.VPCDevOpsRampUp.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATGW.id
  }
  tags = {
    Name = "PriRTBE"
  }
}

resource "aws_route_table" "PubRT" {
  vpc_id = aws_vpc.VPCDevOpsRampUp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
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




resource "aws_security_group" "SG_BASTION" {

  name = "SG_BASTION"
  vpc_id      = aws_vpc.VPCDevOpsRampUp.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["190.26.136.95/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["181.57.222.62/32"]
  }

}
resource "aws_security_group" "SG_LB_EXT_FE" {

  name = "SG_LB_EXT_FE"
  vpc_id      = aws_vpc.VPCDevOpsRampUp.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
resource "aws_security_group" "SG_FE_EC2" {

  name = "SG_FE_EC2"
  vpc_id      = aws_vpc.VPCDevOpsRampUp.id

  ingress {
    from_port   = 3030
    to_port     = 3030
    protocol    = "tcp"
    security_groups  = [aws_security_group.SG_LB_EXT_FE.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups  = [aws_security_group.SG_BASTION.id]
  }

}

resource "aws_security_group" "SG_LB_INT_BE" {

  name = "SG_LB_INT_BE"
  vpc_id      = aws_vpc.VPCDevOpsRampUp.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups  = [aws_security_group.SG_FE_EC2.id]
  }

}


resource "aws_security_group" "SG_BE_EC2" {

  name = "SG_BE_EC2"
  vpc_id      = aws_vpc.VPCDevOpsRampUp.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups  = [aws_security_group.SG_LB_INT_BE.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups  = [aws_security_group.SG_BASTION.id]
  }

}

resource "aws_security_group" "SG_RDS" {

  name = "SG_RDS"
  vpc_id      = aws_vpc.VPCDevOpsRampUp.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups  = [aws_security_group.SG_BASTION.id, aws_security_group.SG_BE_EC2.id]
  }

}


resource "aws_db_subnet_group" "movies_RDS_SNG" {
  name       = "main"
  subnet_ids = [aws_subnet.PriBE1.id, aws_subnet.PriBE2.id]
}

resource "aws_db_instance" "MoviesDB" {
  engine               = "mysql"
  identifier           = "moviesdb"
  allocated_storage    =  20
  engine_version       = "8.0.33"
  instance_class       = "db.t3.micro"
  username             = "applicationuser"
  password             = "applicationuser"
  parameter_group_name = "default.mysql8.0"
  ca_cert_identifier = "rds-ca-rsa2048-g1"
  db_subnet_group_name      = "${aws_db_subnet_group.movies_RDS_SNG.id}"
  availability_zone = "us-east-1a"
  db_name = "movie_db"
  vpc_security_group_ids = ["${aws_security_group.SG_RDS.id}"]
  skip_final_snapshot  = true
  publicly_accessible =  false
}

resource "null_resource" "execute_sql" {
  depends_on = [aws_db_instance.MoviesDB]

  triggers = {
    instance_id = aws_db_instance.MoviesDB.id
  }
  provisioner "local-exec" {
    command = "mysql -h ${aws_db_instance.MoviesDB.endpoint} -P ${aws_db_instance.MoviesDB.port} -u ${aws_db_instance.MoviesDB.username} -p${aws_db_instance.MoviesDB.password} < table_creation.sql"
  }
}