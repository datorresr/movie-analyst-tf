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


resource "aws_subnet" "PubLB1" {
  vpc_id     = var.VPCDevOpsRampUp
  availability_zone = "us-east-1a"
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "PubLB1"
  }
}

resource "aws_subnet" "PubLB2" {
  vpc_id     = var.VPCDevOpsRampUp
  availability_zone = "us-east-1b"
  cidr_block = "10.1.2.0/24"

  tags = {
    Name = "PubLB2"
  }
}

resource "aws_subnet" "PriFE1" {
  vpc_id     = var.VPCDevOpsRampUp
  availability_zone = "us-east-1a"
  cidr_block = "10.1.3.0/24"

  tags = {
    Name = "PriFE1"
  }
}

resource "aws_subnet" "PriFE2" {
  vpc_id     = var.VPCDevOpsRampUp
  availability_zone = "us-east-1b"
  cidr_block = "10.1.4.0/24"

  tags = {
    Name = "PriFE2"
  }
}

resource "aws_subnet" "PriBE1" {
  vpc_id     = var.VPCDevOpsRampUp
  availability_zone = "us-east-1a"
  cidr_block = "10.1.5.0/24"

  tags = {
    Name = "PriBE1"
  }
}

resource "aws_subnet" "PriBE2" {
  vpc_id     = var.VPCDevOpsRampUp
  availability_zone = "us-east-1b"
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

resource "aws_security_group" "SG_LB_EXT_FE" {

  name = "SG_LB_EXT_FE"
  vpc_id      = var.VPCDevOpsRampUp

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
resource "aws_security_group" "SG_FE_EC2" {

  name = "SG_FE_EC2"
  vpc_id      = var.VPCDevOpsRampUp

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
    security_groups  = [var.SG_BASTION]
  }

}

resource "aws_security_group" "SG_LB_INT_BE" {

  name = "SG_LB_INT_BE"
  vpc_id      = var.VPCDevOpsRampUp

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups  = [aws_security_group.SG_FE_EC2.id]
  }

}


resource "aws_security_group" "SG_BE_EC2" {

  name = "SG_BE_EC2"
  vpc_id      = var.VPCDevOpsRampUp

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
    security_groups  = [var.SG_BASTION]
  }

}

resource "aws_security_group" "SG_RDS" {

  name = "SG_RDS"
  vpc_id      = var.VPCDevOpsRampUp

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups  = [var.SG_BASTION, aws_security_group.SG_BE_EC2.id]
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
    command = "mysql -h ${aws_db_instance.MoviesDB.address} -P ${aws_db_instance.MoviesDB.port} -u ${aws_db_instance.MoviesDB.username} -p${aws_db_instance.MoviesDB.password} < table_creation.sql"
  }
}



resource "aws_launch_template" "foo" {
  name = "foo"

  iam_instance_profile {
    name = "arn:aws:iam::700029235138:instance-profile/MySessionManagerRole"
  }

  image_id = "ami-00e985a026a8707df"
  instance_type = "t2.micro"
  key_name = "devopsrampup"

  network_interfaces {
    associate_public_ip_address = false
  }

  vpc_security_group_ids = ["${aws_security_group.SG_BE_EC2.id}"]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "MoviesBackEnd"
    }
  }

  user_data = <<-EOF
              #!/bin/bash
              exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
              cd /home/ec2-user/movie-analyst-api
              su ec2-user -c 'git pull origin master'
              systemctl restart moviesback
              systemctl status moviesback
              EOF
}

