resource "aws_s3_bucket" "f1-wordpress-stage" {
  bucket = "f1-wordpress-stage"

  tags = {
    Name        = "f1-wordpress-stage"
    Environment = "stage"
  }
}

resource "aws_s3_bucket_acl" "wordpress-stage" {
  bucket = aws_s3_bucket.f1-wordpress-stage.id
  acl    = "private"
}

# resource "aws_s3_bucket" "lb-logs" {
#   bucket = "wordpress-stage-lb-logs"

#   tags = {
#     Name        = "wordpress-stage"
#     Environment = "stage"
#   }
# }

# resource "aws_s3_bucket_acl" "lb-logs" {
#   bucket = aws_s3_bucket.lb-logs.id
#   acl    = "private"
# }