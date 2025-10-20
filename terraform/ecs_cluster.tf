# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.project_name}-cluster"
  }
}

# ECS Capacity Provider with Managed Instances
resource "aws_ecs_capacity_provider" "main" {
  name    = "${var.project_name}-capacity-provider"
  cluster = aws_ecs_cluster.main.name

  managed_instances_provider {
    infrastructure_role_arn = aws_iam_role.ecs_infrastructure.arn
    propagate_tags          = "TASK_DEFINITION"

    instance_launch_template {
      ec2_instance_profile_arn = aws_iam_instance_profile.ecs_instance.arn
      monitoring               = "ENABLED"

      network_configuration {
        subnets         = aws_subnet.private[*].id
        security_groups = [aws_security_group.ecs_tasks.id]
      }

      storage_configuration {
        storage_size_gib = 30
      }

      instance_requirements {
        memory_mib {
          min = 512
          max = 2048
        }

        vcpu_count {
          min = 1
          max = 2
        }

        instance_generations = ["current"]
        cpu_manufacturers    = ["intel", "amd"]
      }
    }
  }

  tags = {
    Name = "${var.project_name}-capacity-provider"
  }
}

# Associate Capacity Provider with Cluster
resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = [aws_ecs_capacity_provider.main.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main.name
    weight            = 1
    base              = 1
  }
}
