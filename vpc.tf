resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = var.tags

  enable_dns_hostnames = true
}

resource "aws_subnet" "s1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

  tags = var.tags

  map_public_ip_on_launch = true

  availability_zone = "us-east-1a"
}

resource "aws_subnet" "s2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = var.tags

  map_public_ip_on_launch = true

  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = var.tags
}

resource "aws_route_table_association" "rtba" {
  subnet_id      = aws_subnet.s1.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_route_table_association" "rtbb" {
  subnet_id      = aws_subnet.s2.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_security_group" "sg" {
  name   = "poc_security_group"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}