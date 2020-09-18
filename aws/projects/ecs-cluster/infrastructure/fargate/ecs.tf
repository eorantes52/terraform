resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

output "cluster_name" {
  value = "${aws_ecs_cluster.main.name}"
}