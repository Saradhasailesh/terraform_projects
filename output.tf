output "bucket_state" {
    value = module.s3.bucket_state
}

output "bucket_name_str"{
    value = module.s3.bucket_name_str
}

output "public_ip" {
    value = module.ec2.public_ip
  
}

output "instance_state" {
  value = module.ec2.instance_state
}

output "bucket_name_final" {
  value = module.s3.bucket_name_final
}