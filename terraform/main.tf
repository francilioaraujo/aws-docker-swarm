provider "aws" {
  version = "~> 2.69"
  region  = "us-east-1"
}

provider "http" {
  version = "~> 1.2"
}

data "http" "my_ip" {
  url = "https://ifconfig.me"
}

data "aws_security_groups" "default_sg" {
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

resource "aws_security_group" "my_sg" {
  name = "manager_sg"
  ingress {
    cidr_blocks = ["${chomp(data.http.my_ip.body)}/32"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  tags = {
    Name = "my_sg"
  }
}

resource "aws_key_pair" "my_key" {
  key_name   = "swarm_key"
  public_key = file(var.my_public_key_file)
}

resource "aws_instance" "managers" {
  count                  = var.n_managers
  ami                    = var.base_ami_id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = concat(data.aws_security_groups.default_sg.ids, [aws_security_group.my_sg.id])

  tags = {
    Name = "manager${count.index}"
    role = "manager"
  }
}

resource "aws_instance" "workers" {
  count                  = var.n_workers
  ami                    = var.base_ami_id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = concat(data.aws_security_groups.default_sg.ids, [aws_security_group.my_sg.id])

  tags = {
    Name = "worker${count.index}"
    role = "worker"
  }
}
