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


resource "aws_ecs_task_definition" "vault_frontend_production" {
  family                   = "vault-front-end-production"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "vault-front-end-production"
      image     = "${aws_ecr_repository.vault_frontend.repository_url}:23fbed75b9bc871e28cb6e4b4af3ea23f281fba2"
      cpu       = 10
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        },
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "vault_frontend_production" {
  name            = "vault-front-end-product"
  cluster         = aws_ecs_cluster.vault_production.id
  task_definition = aws_ecs_task_definition.vault_frontend_production.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "vault-front-end-production"
    container_port   = var.app_port
  }

  depends_on = [
    aws_alb_listener.app_port,
    aws_alb_listener.http,
    aws_alb_listener.https,
    aws_iam_role_policy_attachment.ecs_task_execution_role_attach_ecs,
    aws_iam_role_policy_attachment.ecs_task_execution_role_attach_ecr
  ]

  lifecycle {
    # Reference the security group as a whole or individual attributes like `name`
    replace_triggered_by = [aws_security_group.ecs_tasks]
  }
}