terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.17.0"
    }
  }

  backend "s3" {
    bucket       = "olorin-terraform-state"
    key          = "production/terraform.tfstate"
    region       = "us-west-2"
    encrypt      = true
    use_lockfile = true
  }
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
