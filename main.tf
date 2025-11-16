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

#------------------------------------------------------------------Create VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"
  azs  = ["eu-west-1a", "eu-west-1b"]

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

#------------------------------------------------------------------Create Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name   = "ec2-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "TCP"
    security_groups = [aws_security_group.security_group_lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#------------------------------------------------------------------Create Security Group for LB
resource "aws_security_group" "security_group_lb" {
  name   = "security group for lb"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#------------------------------------------------------------------Create EC2
resource "aws_instance" "MyServerEC2" {
  count                  = 2
  ami                    = "ami-0870af38096a5355b"
  instance_type          = "t3.micro"
  subnet_id              = module.vpc.private_subnets[count.index]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = file("install_apache.sh")

  tags = {
    Name = "MyServerEC2-${count.index + 1}"
  }

  depends_on = [
    module.vpc
  ]
}

#------------------------------------------------------------------Create Load Balancer
resource "aws_lb" "application_lb" {
  name                       = "my-application-lb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = module.vpc.public_subnets
  security_groups            = [aws_security_group.security_group_lb.id]
  enable_deletion_protection = false

  tags = {
    Name = "my-application-lb"
  }
}

#------------------------------------------------------------------Target Group for EC2
resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id


  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    interval            = 20
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

#------------------------------------------------------------------Target group attachment
resource "aws_lb_target_group_attachment" "app_tg_attachment" {
  count            = 2
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.MyServerEC2[count.index].id
}

#-------------------------------------------------------------------Listener for LB
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
