resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "demo-vpc"
    Region = data.aws_region.current.name
  }
}

data "aws_availability_zone" "demo-az" {
  name = "us-east-1a"
}

data "aws_region" "current"{}

locals {
  server_name = "demo-server"
  Owner       = "devteam"
}

resource "aws_subnet" "demo-subnet" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zone.demo-az.name
}

resource "aws_security_group" "demo-sg" {
  name        = "allow_http"
  description = "Allow all HTTP connections"
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_internet_gateway" "demo-ig" {
  vpc_id = aws_vpc.demo-vpc.id
}

resource "aws_route_table" "demo_rt" {
  vpc_id = aws_vpc.demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-ig.id
  }
}
resource "aws_route_table_association" "demo-rt-assoc" {
  subnet_id      = aws_subnet.demo-subnet.id
  route_table_id = aws_route_table.demo_rt.id
}

resource "aws_key_pair" "ec2-keypair" {
  key_name   = "ec2-key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "demo-server" {
  ami                         = var.ami
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.demo-sg.id]
  subnet_id                   = aws_subnet.demo-subnet.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ec2-keypair.key_name

  tags = {
    name  = local.server_name
    Owner = local.Owner
  }
}