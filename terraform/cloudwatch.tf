# CloudWatch Log Group for Elessar
resource "aws_cloudwatch_log_group" "elessar" {
  name              = "/ecs/${var.project_name}/elessar"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-elessar-logs"
  }
}

# CloudWatch Log Group for Celebrimbor
resource "aws_cloudwatch_log_group" "celebrimbor" {
  name              = "/ecs/${var.project_name}/celebrimbor"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-celebrimbor-logs"
  }
}
