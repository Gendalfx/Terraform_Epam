#------------------------------------------------------------------
# My Terraform
#
# Performance of laboratory work
#
# Made by Andrii Dukhvin
#------------------------------------------------------------------



provider "aws" {
  region = "eu-west-1"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


resource "aws_instance" "MyServerEC2" {
  count         = 2
  ami           = "ami-0870af38096a5355b"
  instance_type = "t3.micro"

  tags = {
    Name = "MyServerEC2-${count.index + 1}"
  }
}
