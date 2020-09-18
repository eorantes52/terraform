resource "aws_alb" "main" {
  name            = var.alb_name
  subnets         = var.subnets_public_id
  security_groups = [aws_security_group.alb.id]
}

resource "aws_alb_target_group" "default" {
  name        = var.alb_target_group_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_alb_listener" "default" {
  load_balancer_arn = aws_alb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.default.id
    type             = "forward"
  }
}

output "alb_arn" {
  value = "${aws_alb.main.arn}"
}
output "listener_arn" {
  value = "${aws_alb_listener.default.arn}"
}
output "alb_dns_name" {
  value = "${aws_alb.main.dns_name}"
}