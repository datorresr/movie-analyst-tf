resource "aws_security_group" "SG_LB_EXT_FE" {

  name = "SG_LB_EXT_FE"
  vpc_id      = var.VPCDevOpsRampUp

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}