output "bucket_state" {
    value = aws_s3_bucket.ec2_s3_bucket.bucket_domain_name
}

output "bucket_name_str"{
    value = aws_s3_bucket.ec2_s3_bucket.bucket
}

output "bucket_name_final" {
  value = "aws-ec2-s3-bucket-${random_string.random.result}"
}