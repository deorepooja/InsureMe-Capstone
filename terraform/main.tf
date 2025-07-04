provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "insureme_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "InsureMe-VPC"
  }
}

resource "aws_subnet" "insureme_subnet" {
  vpc_id                  = aws_vpc.insureme_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.aws_zone
  tags = {
    Name = "InsureMe-Subnet"
  }
}

resource "aws_security_group" "insureme_sg" {
  name        = "insureme-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.insureme_vpc.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App Port"
    from_port   = 8080
    to_port     = 8080
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
    Name = "InsureMe-SG"
  }
}

resource "aws_instance" "insureme_node" {
  ami                         = var.aws_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.insureme_subnet.id
  vpc_security_group_ids      = [aws_security_group.insureme_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "InsureMe-K8s-Node"
  }
}
