terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.60"
    }
  }

  required_version = ">= 1.4.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ClickGameInstance" {
  ami           = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.sg_ssh_https.id,
  ]

  tags = {
    Name = "Click Game"
  }

   user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
              sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
              sudo apt-get update
              sudo apt-get install -y docker-ce
              sudo systemctl start docker
              sudo systemctl enable docker

              git clone https://github.com/Qpus/clickgame.git

              cd clickgame/

              rm main.tf

              sudo docker compose up -d --build

              EOF
}

resource "aws_security_group" "sg_ssh_https" {
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
}


# resource "aws_vpc" "demo_vpc" {
#   cidr_block       = "10.0.0.0/16"
#   instance_tenancy = "default"

#   tags = {
#     Name = "DemoVPC"
#   }
# }


# resource "aws_route_table" "public_route_table" {
#   vpc_id = aws_vpc.demo_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.demo_igw.id
#   }

#   tags = {
#     Name = "PublicRouteTable"
#   }
# }

# resource "aws_route_table" "private_route_table" {
#   vpc_id = aws_vpc.demo_vpc.id

#   tags = {
#     Name = "PrivateRouteTable"
#   }
# }

# resource "aws_route_table_association" "public_subnet_a_association" {
#   subnet_id      = aws_subnet.public_subnet_a.id
#   route_table_id = aws_route_table.public_route_table.id
# }

# resource "aws_route_table_association" "public_subnet_b_association" {
#   subnet_id      = aws_subnet.public_subnet_b.id
#   route_table_id = aws_route_table.public_route_table.id
# }

# resource "aws_route_table_association" "private_subnet_a_association" {
#   subnet_id      = aws_subnet.private_subnet_a.id
#   route_table_id = aws_route_table.private_route_table.id
# }

# resource "aws_route_table_association" "private_subnet_b_association" {
#   subnet_id      = aws_subnet.private_subnet_b.id
#   route_table_id = aws_route_table.private_route_table.id
# }

# resource "aws_subnet" "public_subnet_a" {
#   vpc_id     = aws_vpc.demo_vpc.id
#   cidr_block = "10.0.0.0/24"

#   tags = {
#     Name = "Public Subnet A"
#   }
# }

# resource "aws_subnet" "public_subnet_b" {
#   vpc_id     = aws_vpc.demo_vpc.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "Public Subnet B"
#   }
# }

# resource "aws_subnet" "private_subnet_a" {
#   vpc_id     = aws_vpc.demo_vpc.id
#   cidr_block = "10.0.16.0/20"

#   tags = {
#     Name = "Private Subnet A"
#   }
# }

# resource "aws_subnet" "private_subnet_b" {
#   vpc_id     = aws_vpc.demo_vpc.id
#   cidr_block = "10.0.32.0/20"

#   tags = {
#     Name = "Private Subnet B"
#   }
# }


# resource "aws_internet_gateway" "demo_igw" {
#   vpc_id = aws_vpc.demo_vpc.id

#   tags = {
#     Name = "DemoIGW"
#   }
# }


