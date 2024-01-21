resource "aws_budgets_budget" "cost" {
  name         = "cost-monthly"
  budget_type  = "COST"
  limit_amount = "1"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = ["crutoitesteurofins@gmail.com"]
  }
}

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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC16LnGcIvNljiVOTtnmgcuBPeytIHwF/67gbeJgiEqBRkNgtQb9391EZuShz8k+hb5PVE+kdWZN88w5HNu1yWDaiHe3p5zOrBi4LzEFmvhecJjOrVV52jz+D4wQi/PcWdW8S1gRvGvHSXujUKzLG7so09ZU308nS/bQbP1knh92ztohBwz+oCx2E5P9lt9INxBp2VFKzhhJn2baxgFExqfCXkGNNpLAz30Jk9LFdmHSHwlTquEBeADgOfUDqZSSwz9+esM0LYJWN7DRbXdOYTot/NVnxMF2M9rNwcDPV586Kwq5TIhLHr5+4fHF/mEUDgYTldVpl58TnTs99zIr0IQpAThh61JuS7LPWIYsfiUGRZEAd3SagieJHPWe1URf5inUXxI1/SXnYNgSziMoyZo3rPH+isPHCISbyYdOze9ntRlo279/NRKFCqD4ly/cMvlJru+1Gi9sYthpS9LdVX/0y/FsW6wyFOsbQBcgaoB2IehOOHQ54dMEgQwJwQwJ+s= ali@Alexandru-Vitalis-MacBook-Air.local"
}

resource "aws_instance" "my-ec2" {
  ami                    = data.aws_ami.windows-dotnet-final.id
  instance_type          = "t2.micro"
  for_each               = toset(var.instance_count)
  key_name               = aws_key_pair.windows.id
  vpc_security_group_ids = [aws_security_group.win_net_sg.id]
  user_data              = <<-EOF
  <powershell>
  cd "${var.app_path}"
  dotnet run --urls="http://localhost:5000"
  </powershell>
  EOF

  tags = {
    Name = "test-instance-${each.key}"
  }
}
