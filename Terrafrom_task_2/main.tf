terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

provider "aws" {
  alias  = "hyderabad"
  region = "ap-south-2"
}

data "aws_vpc" "default1" {
  default = true
}

data "aws_vpc" "default2" {
  provider = aws.hyderabad
  default  = true
}
resource "aws_security_group" "nginx1" {
  name   = "nginx-sg-mumbai"
  vpc_id = data.aws_vpc.default1.id

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

resource "aws_security_group" "nginx2" {
  provider = aws.hyderabad
  name     = "nginx-sg-hyderabad"
  vpc_id   = data.aws_vpc.default2.id

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

resource "aws_instance" "mumbai" {
  ami                    = "ami-081f2952afeacc0ba"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.nginx1.id]

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y nginx
    systemctl enable --now nginx
  EOF

  tags = {
    Name = "nginx-mumbai"
  }
}

resource "aws_instance" "hyderabad" {
  provider               = aws.hyderabad
  ami                    = "ami-0b5edb98441c02861"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.nginx2.id]

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y nginx
    systemctl enable --now nginx
  EOF

  tags = {
    Name = "nginx-hyderabad"
  }
}
