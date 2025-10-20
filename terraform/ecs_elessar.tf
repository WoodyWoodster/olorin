# ECS Task Definition for Elessar (Rails API)
resource "aws_ecs_task_definition" "elessar" {
  family                   = "${var.project_name}-elessar"
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = var.elessar_cpu
  memory                   = var.elessar_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.elessar_task.arn

  container_definitions = jsonencode([
    {
      name      = "elessar"
      image     = "${aws_ecr_repository.elessar.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "RAILS_ENV"
          value = "production"
        },
        {
          name  = "RAILS_LOG_TO_STDOUT"
          value = "true"
        },
        {
          name  = "RAILS_SERVE_STATIC_FILES"
          value = "true"
        }
      ]

      secrets = [
        {
          name      = "DATABASE_URL"
          valueFrom = aws_secretsmanager_secret_version.database_url.arn
        },
        {
          name      = "RAILS_MASTER_KEY"
          valueFrom = aws_secretsmanager_secret_version.rails_master_key.arn
        },
        {
          name      = "SECRET_KEY_BASE"
          valueFrom = aws_secretsmanager_secret_version.secret_key_base.arn
        },
        {
          name      = "DEVISE_JWT_SECRET_KEY"
          valueFrom = aws_secretsmanager_secret_version.devise_jwt_secret.arn
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.elessar.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      healthCheck = {
        command = [
          "CMD-SHELL",
          "curl -f http://localhost:3000/up || exit 1"
        ]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-elessar-task"
  }
}

# ECS Task Definition for Elessar Migrations (one-off task)
resource "aws_ecs_task_definition" "elessar_migrate" {
  family                   = "${var.project_name}-elessar-migrate"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.elessar_cpu
  memory                   = var.elessar_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.elessar_task.arn

  container_definitions = jsonencode([
    {
      name      = "elessar-migrate"
      image     = "${aws_ecr_repository.elessar.repository_url}:latest"
      essential = true

      # Override command to run migrations instead of server
      command = ["bin/rails", "db:prepare"]

      environment = [
        {
          name  = "RAILS_ENV"
          value = "production"
        },
        {
          name  = "RAILS_LOG_TO_STDOUT"
          value = "true"
        }
      ]

      secrets = [
        {
          name      = "DATABASE_URL"
          valueFrom = aws_secretsmanager_secret_version.database_url.arn
        },
        {
          name      = "RAILS_MASTER_KEY"
          valueFrom = aws_secretsmanager_secret_version.rails_master_key.arn
        },
        {
          name      = "SECRET_KEY_BASE"
          valueFrom = aws_secretsmanager_secret_version.secret_key_base.arn
        },
        {
          name      = "DEVISE_JWT_SECRET_KEY"
          valueFrom = aws_secretsmanager_secret_version.devise_jwt_secret.arn
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.elessar.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "migrate"
        }
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-elessar-migrate-task"
  }
}

# ECS Service for Elessar
resource "aws_ecs_service" "elessar" {
  name            = "${var.project_name}-elessar"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.elessar.arn
  desired_count   = var.elessar_desired_count

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main.name
    weight            = 1
    base              = 1
  }

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.elessar.arn
    container_name   = "elessar"
    container_port   = 3000
  }

  health_check_grace_period_seconds = 60
  enable_execute_command            = true

  tags = {
    Name = "${var.project_name}-elessar-service"
  }

  depends_on = [
    aws_lb_listener.http,
    aws_iam_role_policy.ecs_task_execution_ecr,
    aws_db_instance.postgres,
    aws_secretsmanager_secret_version.database_url,
    aws_secretsmanager_secret_version.rails_master_key,
    aws_secretsmanager_secret_version.secret_key_base
  ]
}

# Auto Scaling for Elessar
resource "aws_appautoscaling_target" "elessar" {
  max_capacity       = 10
  min_capacity       = var.elessar_desired_count
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.elessar.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# CPU-based auto-scaling policy
resource "aws_appautoscaling_policy" "elessar_cpu" {
  name               = "${var.project_name}-elessar-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.elessar.resource_id
  scalable_dimension = aws_appautoscaling_target.elessar.scalable_dimension
  service_namespace  = aws_appautoscaling_target.elessar.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}

# Memory-based auto-scaling policy
resource "aws_appautoscaling_policy" "elessar_memory" {
  name               = "${var.project_name}-elessar-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.elessar.resource_id
  scalable_dimension = aws_appautoscaling_target.elessar.scalable_dimension
  service_namespace  = aws_appautoscaling_target.elessar.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 80.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}
