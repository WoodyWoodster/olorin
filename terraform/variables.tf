variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g., production, staging)"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "olorin"
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# RDS Configuration
variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "olorin_production"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "olorin"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS in GB"
  type        = number
  default     = 20
}

variable "db_backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

# ECS Configuration
variable "elessar_cpu" {
  description = "CPU units for Elessar (1024 = 1 vCPU)"
  type        = number
  default     = 512
}

variable "elessar_memory" {
  description = "Memory for Elessar in MB"
  type        = number
  default     = 1024
}

variable "elessar_desired_count" {
  description = "Desired number of Elessar tasks"
  type        = number
  default     = 1
}

variable "celebrimbor_cpu" {
  description = "CPU units for Celebrimbor (1024 = 1 vCPU)"
  type        = number
  default     = 256
}

variable "celebrimbor_memory" {
  description = "Memory for Celebrimbor in MB"
  type        = number
  default     = 512
}

variable "celebrimbor_desired_count" {
  description = "Desired number of Celebrimbor tasks"
  type        = number
  default     = 1
}

# Application Configuration
variable "rails_master_key" {
  description = "Rails master key for encrypted credentials"
  type        = string
  sensitive   = true
}

variable "secret_key_base" {
  description = "Rails secret key base"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Domain name for the application (optional)"
  type        = string
  default     = ""
}
