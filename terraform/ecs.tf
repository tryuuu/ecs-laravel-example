resource "aws_ecs_cluster" "example_cluster" {
  name = "example-cluster"
}
resource "aws_cloudwatch_log_group" "example_log_group" {
  name = "/ecs/example-cluster"
}
resource "aws_ecs_task_definition" "example_task" {
  family                   = "example"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.example_ecs_execution_role.arn
  
  container_definitions = jsonencode([
    {
      name  = "nginx-container",
      image = "361452760157.dkr.ecr.ap-northeast-1.amazonaws.com/example-nginx:latest",
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80,
          protocol      = "tcp"
        }
      ],
	logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/example-cluster"
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = "nginx"
        }
      }
    },
    {
      name  = "php-container",
      image = "361452760157.dkr.ecr.ap-northeast-1.amazonaws.com/example-php:latest",
      entryPoint       = ["sh", "-c"],
      command          = ["php-fpm && php artisan config:cache && php artisan view:cache && php artisan route:cache && php artisan migrate --force && chown -hR www-data:www-data storage bootstrap/cache && composer install --optimize-autoloader --no-dev"],
      workingDirectory = "/var/www/html/app",
	logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/example-cluster"
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = "php"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "example_service" {
  name            = "example-service"
  cluster         = aws_ecs_cluster.example_cluster.id
  task_definition = aws_ecs_task_definition.example_task.arn
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.example_target_group.arn
    container_name   = "nginx-container"
    container_port   = 80
  }

  network_configuration {
    subnets = [aws_subnet.example_public_subnet_1.id, aws_subnet.example_public_subnet_2.id]
    security_groups = [aws_security_group.example_ecs_sg.id]
    assign_public_ip = true
  }

  desired_count = 1
}
resource "aws_iam_role" "example_ecs_execution_role" {
  name = "my_ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "example_ecs_execution_role_policy" {
  role       = aws_iam_role.example_ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

