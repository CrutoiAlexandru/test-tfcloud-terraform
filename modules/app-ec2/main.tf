
data "aws_ami" "windows-dotnet-final" {
  filter {
    name   = "name"
    values = ["dotnet-windows-final"]
  }
  owners = ["self"]
}

resource "aws_security_group" "net_win_sg" {
  name = "dotnet-windows-security-group"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_instance" "my-ec2" {
  ami                    = data.aws_ami.windows-dotnet-final.id
  instance_type          = "t2.micro"
  for_each               = toset(var.instance_count)
  vpc_security_group_ids = [aws_security_group.net_win_sg.id]

  tags = {
    Name = "test-instance-${each.key}"
  }
}
