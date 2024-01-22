
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

resource "aws_key_pair" "windows" {
  key_name   = "windows-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZCRTiK8jiwZeS/Paoo6ILZeFb2K6COqh6L5oVyYzKgXeBywSkwZ7JPsLK014E7YkU4Jmdcgi6YtYNwFOi3rP6IsN7hnX8alEr6m/c2CUJ7Dy6koOdfWSdtwXu9NmJNqtcYh8yApCjGpLCLoZXN+CAs1WmdNrazP/RN9aYgCm6/vBgI9pgl+OyH2uu8ke5WSsy/7Rpwz7Vx/x8NkDitx/EOzaXlmfXKL+BNB9JxG1WR+Lv0kfiaIR/P0Al9T4PzClDMyuaXVjnDGYkHJXDqp6OrW5HnuxbyLaZPxZ0Ej811/NdEOrXrnN4mjljwW08v2v65wu+FRatbl2FVRg3PpZn89D0rNFDtysPL3IZW3A0ff/FfWo4iFsrK/2ngnaOMaYDxqEjbBN19tf92FvwLW2fqrm7r8SOfdnKWlIvNQhgvHnrWLOqUeNtxzeGF9ee7ZZUrbcbR+SzRPC71qmxDQMZ3vA13AcYPrn7zPr55Ot8Nn90rFMoxt4zixR3D4GDJRE= ali@192.168.1.10"
}

resource "aws_instance" "my-ec2" {
  ami                    = data.aws_ami.windows-dotnet-final.id
  instance_type          = "t2.micro"
  for_each               = toset(var.instance_count)
  key_name               = aws_key_pair.windows.id
  vpc_security_group_ids = [aws_security_group.net_win_sg.id]
  user_data              = <<-EOF
  <powershell>
  cd "C:\App"
  dotnet run --urls="http://localhost:80" &
  </powershell>
  EOF

  tags = {
    Name = "test-instance-${each.key}"
  }
}
