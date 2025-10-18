# ECS Task Definition for Celebrimbor (Vue Frontend)
resource "aws_ecs_task_definition" "celebrimbor" {
  family                   = "${var.project_name}-celebrimbor"
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = var.celebrimbor_cpu
  memory                   = var.celebrimbor_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.celebrimbor_task.arn

  container_definitions = jsonencode([
    {
      name      = "celebrimbor"
      image     = "${aws_ecr_repository.celebrimbor.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.celebrimbor.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      healthCheck = {
        command = [
          "CMD-SHELL",
          "wget --no-verbose --tries=1 --spider http://localhost || exit 1"
        ]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 30
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-celebrimbor-task"
  }
}

# ECS Service for Celebrimbor
resource "aws_ecs_service" "celebrimbor" {
  name            = "${var.project_name}-celebrimbor"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.celebrimbor.arn
  desired_count   = var.celebrimbor_desired_count

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main.name
    weight            = 1
    base              = 0
  }

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.celebrimbor.arn
    container_name   = "celebrimbor"
    container_port   = 80
  }

  health_check_grace_period_seconds = 30
  enable_execute_command            = true

  tags = {
    Name = "${var.project_name}-celebrimbor-service"
  }

  depends_on = [
    aws_lb_listener.http,
    aws_iam_role_policy.ecs_task_execution_ecr,
    aws_ecs_service.elessar
  ]
}

# Auto Scaling for Celebrimbor
resource "aws_appautoscaling_target" "celebrimbor" {
  max_capacity       = 10
  min_capacity       = var.celebrimbor_desired_count
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.celebrimbor.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# CPU-based auto-scaling policy
resource "aws_appautoscaling_policy" "celebrimbor_cpu" {
  name               = "${var.project_name}-celebrimbor-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.celebrimbor.resource_id
  scalable_dimension = aws_appautoscaling_target.celebrimbor.scalable_dimension
  service_namespace  = aws_appautoscaling_target.celebrimbor.service_namespace

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
resource "aws_appautoscaling_policy" "celebrimbor_memory" {
  name               = "${var.project_name}-celebrimbor-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.celebrimbor.resource_id
  scalable_dimension = aws_appautoscaling_target.celebrimbor.scalable_dimension
  service_namespace  = aws_appautoscaling_target.celebrimbor.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 80.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}
