resource "aws_s3_bucket" "f1-wordpress-prod" {
  bucket = "f1-wordpress-prod"

  tags = {
    Name        = "f1-wordpress-prod"
    Environment = "prod"
  }
}

resource "aws_s3_bucket_acl" "wordpress-prod" {
  bucket = aws_s3_bucket.f1-wordpress-prod.id
  acl    = "private"
}

# resource "aws_s3_bucket" "lb-logs" {
#   bucket = "wordpress-prod-lb-logs"

#   tags = {
#     Name        = "wordpress-prod"
#     Environment = "prod"
#   }
# }

# resource "aws_s3_bucket_acl" "lb-logs" {
#   bucket = aws_s3_bucket.lb-logs.id
#   acl    = "private"
# }