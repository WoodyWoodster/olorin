output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.main.zone_id
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.postgres.endpoint
  sensitive   = true
}

output "rds_database_name" {
  description = "RDS database name"
  value       = aws_db_instance.postgres.db_name
  sensitive   = true
}

output "ecr_elessar_url" {
  description = "ECR repository URL for Elessar"
  value       = aws_ecr_repository.elessar.repository_url
}

output "ecr_celebrimbor_url" {
  description = "ECR repository URL for Celebrimbor"
  value       = aws_ecr_repository.celebrimbor.repository_url
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "elessar_service_name" {
  description = "Name of the Elessar ECS service"
  value       = aws_ecs_service.elessar.name
}

output "celebrimbor_service_name" {
  description = "Name of the Celebrimbor ECS service"
  value       = aws_ecs_service.celebrimbor.name
}
