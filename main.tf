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

resource "aws_instance" "my-ec2" {
  ami           = "ami-0faab6bdbac9486fb"
  instance_type = "t2.micro"
  count         = var.instance_count

  tags = {
    Name = "test-instance-${count.index + 1}"
  }
}