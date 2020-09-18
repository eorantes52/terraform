resource "aws_s3_bucket" "main" {
  bucket 		= var.bucket_name
  acl 			= "private"
  force_destroy = true
}