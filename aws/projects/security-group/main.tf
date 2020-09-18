resource "aws_security_group" "main" {
  name        = var.security_group_name
  description = "Managed by Terraform"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["var.private_cidr"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

output "security_group_id" {
  value = "${aws_security_group.main.id}"
}