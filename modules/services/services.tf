//LOAD BALANCER DEFINITION

resource "aws_lb" "ecs-alb" {
  name               = "${var.env}-${var.serv}-alb"
  internal           = var.isInternal
  load_balancer_type = "application"
  subnets            = [var.subnet_LB1_id, var.subnet_LB2_id]
  security_groups    = [var.SG_LB_id]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "ecs_target_group" {
  name     = "${var.env}-${var.serv}-target-group"
  port     = var.listener_port
  protocol = "HTTP"
  vpc_id   = var.VPCDevOpsRampUp # Reemplaza con el ID de tu VPC
  target_type = "ip"
}

resource "aws_lb_listener" "ecs_lb_listener" {
  load_balancer_arn = aws_lb.ecs-alb.id
  port              = var.lb_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ecs_target_group.id
    type             = "forward"
  }
}

//TASK DEFINITION

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.env}-${var.serv}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::700029235138:role/ecsTaskExecutionRole"

  cpu = "1024"
  memory = "2048"

  container_definitions = <<DEFINITION
[
  {
    "image": "${var.container}",
    "cpu": 1024,
    "memory": 2048,
    "name": "${var.env}-${var.serv}-container",
    "networkMode": "awsvpc",
    "environment": [
      {"name": "DB_HOST", "value": "${var.moviesDB_address}"},
      {"name": "DB_USER", "value": "${var.moviesDB_username}"},
      {"name": "DB_PASS", "value": "${var.moviesDB_password}L"},
      {"name": "BACK_HOST", "value": "${var.load_balancer_ip}"}
    ],
    "portMappings": [
      {
        "containerPort": ${var.listener_port},
        "hostPort": ${var.listener_port}
      }
    ]
  }
]
DEFINITION
  
}

//CLUSTER DEFINITION

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.env}-${var.serv}-ECS-Cluster"
}

//ECS SERVICE DEFINITION

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.env}-${var.serv}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 3
  launch_type     = "FARGATE"



  network_configuration {
    subnets = [var.subnet_ECS1_id, var.subnet_ECS2_id] 
    security_groups = [var.SG_ECS_id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    container_name   = "${var.env}-${var.serv}-container"
    container_port   = var.listener_port
  }


  //minimum_healthy_percent = 0
  //maximum_percent = 200
  //enable_ecs_managed_tags = true

  //capacity_provider_strategy {
  //  capacity_provider = "FARGATE"
  //  weight           = 1
  //}

  depends_on = [aws_lb_listener.ecs_lb_listener]
}



