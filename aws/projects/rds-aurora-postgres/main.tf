data "aws_subnet_ids" "private" {
	vpc_id = var.vpc_id

	tags = {
    Tier = "Private"
  }
}

resource "aws_security_group" "aurora" {
  name        = var.rds_security_group_name
  description = "allow traffic"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.db_port
    to_port         = var.db_port
    cidr_blocks     = [var.private_cidr]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "default" {
  name        = var.rds_name
  description = var.rds_name
  subnet_ids  = var.subnets_private_id
}

resource "aws_rds_cluster" "postgres" {
  cluster_identifier        = var.rds_name
  engine                    = var.engine
  engine_version            = "10.7"
  availability_zones        = var.azones
  vpc_security_group_ids    = [aws_security_group.aurora.id]
  db_subnet_group_name      = aws_db_subnet_group.default.name
  database_name             = var.db_name
  master_username           = var.master_username
  master_password           = var.rds_psswrd
  backup_retention_period   = 5
  engine_mode               = var.engine_mode
  enable_http_endpoint      = "true"
  skip_final_snapshot       = "true"
  apply_immediately         = "true"

  scaling_configuration {
    auto_pause               = true
    max_capacity             = 64
    min_capacity             = 8
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}