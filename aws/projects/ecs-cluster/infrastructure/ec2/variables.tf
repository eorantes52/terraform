variable "alb_name" {}
variable "alb_target_group_name" {}
variable "aws_region" {}
variable "cluster_name" {}
variable "vpc_id" {}
variable "subnets_private_id" {
	type = "list"
}
variable "subnets_public_id" {
	type = "list"
}
variable "private_a" {}
variable "private_b" {}
variable "public_a" {}
variable "public_b" {}
variable "user_data_name" {}
variable "launch_configuration_name" {}
variable "key_name" {}
variable "image_id" {}
variable "instance_type" {}
variable "iam_instance_profile" {}
variable "volume_size" {}
variable "asg_name" {}
variable "asg_min" {}
variable "asg_max" {}
variable "desired_capacity" {}
variable "env" {}