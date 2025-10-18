# AWS Secrets Manager for sensitive application secrets

# Database URL Secret
resource "aws_secretsmanager_secret" "database_url" {
  name        = "${var.project_name}/database_url"
  description = "PostgreSQL database connection URL"

  tags = {
    Name = "${var.project_name}-database-url"
  }
}

resource "aws_secretsmanager_secret_version" "database_url" {
  secret_id = aws_secretsmanager_secret.database_url.id
  secret_string = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.postgres.endpoint}/${var.db_name}"
}

# Rails Master Key Secret
resource "aws_secretsmanager_secret" "rails_master_key" {
  name        = "${var.project_name}/rails_master_key"
  description = "Rails master key for encrypted credentials"

  tags = {
    Name = "${var.project_name}-rails-master-key"
  }
}

resource "aws_secretsmanager_secret_version" "rails_master_key" {
  secret_id     = aws_secretsmanager_secret.rails_master_key.id
  secret_string = var.rails_master_key
}

# Rails Secret Key Base
resource "aws_secretsmanager_secret" "secret_key_base" {
  name        = "${var.project_name}/secret_key_base"
  description = "Rails secret key base for session encryption"

  tags = {
    Name = "${var.project_name}-secret-key-base"
  }
}

resource "aws_secretsmanager_secret_version" "secret_key_base" {
  secret_id     = aws_secretsmanager_secret.secret_key_base.id
  secret_string = var.secret_key_base
}
