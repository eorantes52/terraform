data "template_file" "init" {
  template = "${file("./templates/ecs/${var.task_file_name}")}"

  vars = {
    container_name                = var.container_name
    app_image                     = var.app_image
    container_cpu                 = var.container_cpu
    container_memory              = var.container_memory
    container_port                = var.container_port
    aws_region                    = var.aws_region
    env_var_1                     = var.env_var_1
    env_var_2                     = var.env_var_2
    env_var_3                     = var.env_var_3
    env_var_4                     = var.env_var_4
    env_var_5                     = var.env_var_5
    docker_hub_arn                = var.docker_hub_arn
  }
}

output "init_output" {
  value = data.template_file.init.rendered
}

resource "aws_alb_target_group" "main" {
  name        = var.container_name
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    interval            = "30"
    path                = var.health_check_path
    healthy_threshold   = "5"
    unhealthy_threshold = "4"
    timeout             = "3"
  }
}

resource "aws_alb_listener_rule" "main" {
  listener_arn  = var.listener_arn

  action {
    type = "forward"
    target_group_arn = "${aws_alb_target_group.main.arn}"
  }

  condition {
    path_pattern {
      values = [var.service_path]
    }
  }
}

resource "aws_ecs_task_definition" "main" {
  family                   = var.container_name
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.task_definition_role_arn
  requires_compatibilities = ["EC2"]
  volume {
    name      = "service_volume"
  }
  container_definitions    = data.template_file.init.rendered
}

resource "aws_ecs_service" "main" {
  name            = var.container_name
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.app_count
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = aws_alb_target_group.main.id
    container_name   = var.container_name
    container_port   = var.container_port
  }
}