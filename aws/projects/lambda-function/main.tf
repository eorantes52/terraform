resource "aws_lambda_function" "main" {
  function_name = var.function_name
  filename      = var.function_filename
  handler       = var.function_handler
  role          = var.lambda_role_arn
  runtime       = var.function_runtime
  timeout       = var.function_timeout
  memory_size   = var.function_memory_size

  source_code_hash = var.source_code_hash

  layers        = [var.function_layer_arn]

  vpc_config {
    subnet_ids         = var.subnets_private_id
    security_group_ids = [var.security_group_id]
  }

  environment {
    variables = {
      REGION: var.aws_region
    	ENV_VAR_1: var.env_var_1
      ENV_VAR_2: var.env_var_2
      ENV_VAR_3: var.env_var_3
    }
  }
}

output "lambda_function_arn" {
  value = "${aws_lambda_function.main.arn}"
}