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
  target_type = "ip"

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
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.init.rendered
}

resource "aws_ecs_service" "main" {
  name            = var.container_name
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.sg_task_id]
    subnets          = var.subnets_private_id
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.id
    container_name   = var.container_name
    container_port   = var.container_port
  }
}

resource "aws_appautoscaling_target" "target" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = var.ecs_auto_scale_role_arn
  min_capacity       = 1
  max_capacity       = 1
}

resource "aws_appautoscaling_policy" "up" {
  name               = "service_scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

resource "aws_appautoscaling_policy" "down" {
  name               = "service_scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}