terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">=5.50.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "vault-infrastructure"
}

// ECR
resource "aws_ecr_repository" "vault_frontend" {
  name                 = "vault-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

// ECS
resource "aws_ecs_cluster" "vault_production" {
  name = "vault-production"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "vault_production" {
  cluster_name = aws_ecs_cluster.vault_production.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attach" {
    role       = aws_iam_role.ecs_task_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "vault_frontend_production" {
  family                   = "vault-front-end-production"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "${aws_iam_role.ecs_task_execution_role.arn}"

  container_definitions = jsonencode([
    {
      name  = "vault-front-end-production"
      image = "${aws_ecr_repository.vault_frontend.repository_url}:latest"
      cpu       = 10
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "vault_frontend_production" {
  name            = "mongodb"
  cluster         = aws_ecs_cluster.vault_production.id
  task_definition = aws_ecs_task_definition.vault_frontend_production.arn
  desired_count   = 3

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  # load_balancer {
  #   target_group_arn = aws_lb_target_group.foo.arn
  #   container_name   = "mongo"
  #   container_port   = 8080
  # }

  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  # }
}
  
  