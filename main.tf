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
    subscriber_email_addresses = ["${var.subscriber_email}"]
  }
}

module "app-ec2" {
  source         = "./modules/app-ec2"
  instance_count = []
  storage        = 30
}
