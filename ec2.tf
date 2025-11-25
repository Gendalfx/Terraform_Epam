#------------------------------------------------------------------Create EC2
resource "aws_instance" "MyServerEC2" {
  count                  = 2
  ami                    = data.aws_ami.ami_amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = module.vpc.private_subnets[count.index]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = templatefile("install_apache.sh", {
    color = var.colors[count.index]
    index = count.index + 1
  })

  tags = {
    Name = "MyServerEC2-${count.index + 1}"
  }
}

data "aws_ami" "ami_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "state"
    values = ["available"]
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
