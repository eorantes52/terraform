resource "aws_dynamodb_table" "main" {
  name            = var.dynamo_table_name
  billing_mode    = var.dynamo_table_billing
  hash_key        = var.dynamo_hash_key_name
  range_key       = var.dynamo_range_key_name

  attribute {
    name  = var.dynamo_hash_key_name
    type  = "S"
  }

  attribute {
    name  = var.dynamo_range_key_name
    type  = "S"
  }

  tags = {
    STAGE = var.env
  }
}