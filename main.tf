terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "tls_private_key" "webt1_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "private_key" {
  content         = tls_private_key.webt1_private_key.private_key_pem
  filename        = "webserver_key.pem"
  file_permission = 0400
}
resource "aws_key_pair" "task1_key" {
  key_name   = "task1_key"
  public_key = tls_private_key.webt1_private_key.public_key_openssh
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http"
  description = "Allow http inbound traffic"


  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "ssh"
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


  tags = {
    Name = "allow_http_ssh"
  }
}

resource "aws_instance" "task1_instance" {
  ami               = "ami-08e2d37b6a0129927"
  instance_type     = "t2.micro"
  key_name          = aws_key_pair.task1_key.key_name
  availability_zone = "us-west-2c"
  security_groups   = ["${aws_security_group.allow_http_ssh.name}"]


  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = aws_instance.task1_instance.public_ip
    port        = 22
    private_key = tls_private_key.webt1_private_key.private_key_pem
  }

  tags = {
    Name = "webserver_task1"
  }
}
