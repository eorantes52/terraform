resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

data "template_file" "user_data" {
    template = "${file("./templates/ecs/${var.user_data_name}")}"

    vars = {
        cluster_name    = var.cluster_name
    }
}

data "aws_subnet" "public_a" {
   filter {
     name   = "tag:Name"
     values = ["${var.public_a}"]
   }
   vpc_id =  "${var.vpc_id}"
 }

 data "aws_subnet" "public_b" {
   filter {
     name   = "tag:Name"
     values = ["${var.public_b}"]
   }
   vpc_id =  "${var.vpc_id}"
 }

resource "aws_launch_configuration" "main" {
  name                 = var.launch_configuration_name
  key_name             = var.key_name
  image_id             = var.image_id
  instance_type        = var.instance_type
  iam_instance_profile = var.iam_instance_profile
  security_groups      = [aws_security_group.service.id]
  user_data            = data.template_file.user_data.rendered

  root_block_device {
    volume_size = var.volume_size
  }

  lifecycle {
    create_before_destroy = true
  }
    
}

resource "aws_autoscaling_group" "main" {
  name                 = var.asg_name
  availability_zones   = [data.aws_subnet.public_a.availability_zone,data.aws_subnet.public_b.availability_zone]
  launch_configuration = aws_launch_configuration.main.name
  min_size             = var.asg_min
  max_size             = var.asg_max
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = var.subnets_public_id
  force_delete         = true
  
  tag {
    key                 = "Name"
    value               = var.launch_configuration_name
    propagate_at_launch = true
  }
  
  tag {
    key                 = "Env"
    value               = var.env
    propagate_at_launch = true
  }
}

output "cluster_name" {
  value = "${aws_ecs_cluster.main.name}"
}