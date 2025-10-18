terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.17.0"
    }
  }

  # Uncomment and configure for remote state
  # backend "s3" {
  #   bucket         = "olorin-terraform-state"
  #   key            = "production/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "olorin-terraform-locks"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "olorin-erp"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
