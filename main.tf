


resource "aws_vpc" "VPCDevOpsRampUp" {
  cidr_block       = "10.1.0.0/16"

  tags = {
    Name = "VPCDevOpsRampUp"
  }
}

resource "aws_subnet" "PubSN1" {
  vpc_id     = aws_vpc.VPCDevOpsRampUp.id
  availability_zone = "us-east-1a"
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "PubSN1"
  }
}

resource "aws_subnet" "PubSN2" {
  vpc_id     = aws_vpc.VPCDevOpsRampUp.id
  availability_zone = "us-east-1b"
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "PubSN2"
  }
}

resource "aws_subnet" "PubSN1" {
  vpc_id     = aws_vpc.VPCDevOpsRampUp.id
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "PubSN1"
  }
}

resource "aws_subnet" "PubSN1" {
  vpc_id     = aws_vpc.VPCDevOpsRampUp.id
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "PubSN1"
  }
}