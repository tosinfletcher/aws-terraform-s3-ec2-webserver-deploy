resource "aws_vpc" "tfletcher_vpc" {
  cidr_block         = var.cidr_block
  instance_tenancy   = "default"
  enable_dns_support = true

  tags = {
    Name = "tfletcher_vpc"
  }
}


resource "aws_internet_gateway" "tfletcher_igw" {
  vpc_id = aws_vpc.tfletcher_vpc.id

  tags = {
    Name = "tfletcher_igw"
  }
}

resource "aws_default_route_table" "tfletcher_default_rt" {
  default_route_table_id = aws_vpc.tfletcher_vpc.default_route_table_id

  tags = {
    Name = "tfletcher_default_rt"
  }
}

resource "aws_route_table" "tfletcher_public_rt" {
  vpc_id = aws_vpc.tfletcher_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tfletcher_igw.id
  }

  tags = {
    Name = "tfletcher_public_rt"
  }
}

resource "aws_subnet" "tfletcher_public" {
  vpc_id            = aws_vpc.tfletcher_vpc.id
  cidr_block        = var.cidr_public_subnet
  availability_zone = "us-east-1a"

  tags = {
    Name = "tfletcher_public"
  }
}

resource "aws_subnet" "tfletcher_private" {
  vpc_id            = aws_vpc.tfletcher_vpc.id
  cidr_block        = var.cidr_private_subnet
  availability_zone = "us-east-1b"

  tags = {
    Name = "tfletcher_private"
  }
}

resource "aws_route_table_association" "tfletcher_public_rt_a" {
  subnet_id      = aws_subnet.tfletcher_public.id
  route_table_id = aws_route_table.tfletcher_public_rt.id
}

resource "aws_security_group" "tfletcher_sg" {
  name        = "tfletcher_sg"
  description = "Allow SSH, HTTPs & HTTp inbound traffic"
  vpc_id      = aws_vpc.tfletcher_vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Https from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Http from VPC"
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

  tags = {
    Name = "tfletcher_sg"
  }

}

