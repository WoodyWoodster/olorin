# ECS Infrastructure Role (for ECS to manage instances)
resource "aws_iam_role" "ecs_infrastructure" {
  name = "${var.project_name}-ecs-infrastructure-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ecs-infrastructure-role"
  }
}

resource "aws_iam_role_policy" "ecs_infrastructure" {
  name = "${var.project_name}-ecs-infrastructure-policy"
  role = aws_iam_role.ecs_infrastructure.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CreateLaunchTemplateForManagedInstances"
        Effect = "Allow"
        Action = ["ec2:CreateLaunchTemplate"]
        Resource = ["arn:aws:ec2:*:*:launch-template/*"]
        Condition = {
          StringEquals = {
            "aws:RequestTag/AmazonECSManaged" = "true"
          }
        }
      },
      {
        Sid    = "CreateLaunchTemplateVersionsForManagedInstances"
        Effect = "Allow"
        Action = [
          "ec2:CreateLaunchTemplateVersion",
          "ec2:ModifyLaunchTemplate"
        ]
        Resource = ["arn:aws:ec2:*:*:launch-template/*"]
        Condition = {
          StringEquals = {
            "ec2:ManagedResourceOperator" = "ecs.amazonaws.com"
          }
        }
      },
      {
        Sid    = "ProvisionEC2InstancesForManagedInstances"
        Effect = "Allow"
        Action = ["ec2:CreateFleet"]
        Resource = [
          "arn:aws:ec2:*:*:fleet/*",
          "arn:aws:ec2:*:*:instance/*",
          "arn:aws:ec2:*:*:network-interface/*",
          "arn:aws:ec2:*:*:launch-template/*",
          "arn:aws:ec2:*:*:security-group/*",
          "arn:aws:ec2:*:*:subnet/*",
          "arn:aws:ec2:*:*:volume/*",
          "arn:aws:ec2:*:*:image/*"
        ]
      },
      {
        Sid    = "RunEC2InstancesForManagedInstances"
        Effect = "Allow"
        Action = ["ec2:RunInstances"]
        Resource = [
          "arn:aws:ec2:*:*:instance/*",
          "arn:aws:ec2:*:*:network-interface/*",
          "arn:aws:ec2:*:*:security-group/*",
          "arn:aws:ec2:*:*:subnet/*",
          "arn:aws:ec2:*:*:volume/*",
          "arn:aws:ec2:*:*:image/*",
          "arn:aws:ec2:*:*:launch-template/*"
        ]
      },
      {
        Sid      = "TagEC2ResourcesForManagedInstances"
        Effect   = "Allow"
        Action   = ["ec2:CreateTags"]
        Resource = ["*"]
      },
      {
        Sid    = "PassIAMRoleToEC2ForManagedInstances"
        Effect = "Allow"
        Action = ["iam:PassRole"]
        Resource = [aws_iam_role.ecs_instance.arn]
        Condition = {
          StringEquals = {
            "iam:PassedToService" = "ec2.amazonaws.com"
          }
        }
      },
      {
        Sid    = "CreateServiceLinkedRoleForSpot"
        Effect = "Allow"
        Action = ["iam:CreateServiceLinkedRole"]
        Resource = ["arn:aws:iam::*:role/aws-service-role/spot.amazonaws.com/*"]
        Condition = {
          StringEquals = {
            "iam:AWSServiceName" = "spot.amazonaws.com"
          }
        }
      },
      {
        Sid    = "DescribeEC2Resources"
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs"
        ]
        Resource = ["*"]
      },
      {
        Sid    = "TerminateEC2InstancesForManagedInstances"
        Effect = "Allow"
        Action = ["ec2:TerminateInstances"]
        Resource = ["arn:aws:ec2:*:*:instance/*"]
        Condition = {
          StringEquals = {
            "ec2:ManagedResourceOperator" = "ecs.amazonaws.com"
          }
        }
      }
    ]
  })
}

# ECS Instance Role (for EC2 instances)
resource "aws_iam_role" "ecs_instance" {
  name = "${var.project_name}-ecs-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ecs-instance-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_instance" {
  role       = aws_iam_role.ecs_instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance" {
  name = "${var.project_name}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance.name

  tags = {
    Name = "${var.project_name}-ecs-instance-profile"
  }
}

# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project_name}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ecs-task-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Additional policy for ECR access
resource "aws_iam_role_policy" "ecs_task_execution_ecr" {
  name = "${var.project_name}-ecs-task-execution-ecr-policy"
  role = aws_iam_role.ecs_task_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          "arn:aws:secretsmanager:${var.aws_region}:*:secret:${var.project_name}/*"
        ]
      }
    ]
  })
}

# ECS Task Role for Elessar
resource "aws_iam_role" "elessar_task" {
  name = "${var.project_name}-elessar-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-elessar-task-role"
  }
}

# Policy for Elessar (add specific permissions as needed)
resource "aws_iam_role_policy" "elessar_task" {
  name = "${var.project_name}-elessar-task-policy"
  role = aws_iam_role.elessar_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# ECS Task Role for Celebrimbor
resource "aws_iam_role" "celebrimbor_task" {
  name = "${var.project_name}-celebrimbor-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-celebrimbor-task-role"
  }
}

# Policy for Celebrimbor
resource "aws_iam_role_policy" "celebrimbor_task" {
  name = "${var.project_name}-celebrimbor-task-policy"
  role = aws_iam_role.celebrimbor_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}
