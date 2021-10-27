terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

# Create EC2 instance
resource "aws_instance" "fleet_server" {
  ami           = "ami-0e8286b71b81c3cc1"
  instance_type = "t2.nano"

  vpc_security_group_ids = [ 
    aws_security_group.sg_for_fleet.id
  ]

  tags = {
    "Terraform" : "true"
  }
}

# Create a VPC (Virtual Private Cloud)
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Create a Security Group
resource "aws_security_group" "sg_for_fleet" {
  name        = "sg_for_fleet"
  description = "Allow standart http and https ports inbound and everything outbound"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]    
  }

  tags = {
    "Terraform" : "true"
  }
}