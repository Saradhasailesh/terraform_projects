resource "random_string" "random" {
  length = 8
  upper = false
  lower = true
  special = false
}

resource "aws_s3_bucket" "ec2_s3_bucket" {
bucket = "aws-ec2-s3-bucket-${random_string.random.result}"
force_destroy = true
tags = {
  Name = "aws-ec2-s3-bucket-${random_string.random.result}"
}
}
resource "aws_s3_object" "test_object" {
  bucket = aws_s3_bucket.ec2_s3_bucket.id
  key = "index.html"
  source = "./modules/s3/index.html"
  etag = filemd5("./modules/s3/index.html")
}
