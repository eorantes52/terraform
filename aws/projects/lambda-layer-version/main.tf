resource "aws_lambda_layer_version" "main" {
  filename        = var.lambda_path
  layer_name      = var.lambda_layer_name

  compatible_runtimes = [var.layer_runtime]

}

output "lambda_layer_arn" {
  value = "${aws_lambda_layer_version.main.arn}"
}