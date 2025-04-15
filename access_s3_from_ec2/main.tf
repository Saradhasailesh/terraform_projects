provider "aws" {
  region = var.region

}

module "vpc" {
  source = "./modules/vpc/"
  region = var.region
}

module "ec2" {
  source             = "./modules/ec2/"
  subnet_id          = module.vpc.subnet_id
  security_group_ids = module.vpc.security_group_ids
  region             = var.region
  ami                = var.ami
  instance_type      = var.instance_type
  key_name           = var.key_name
  public_key         = var.public_key
  bucket_name_final      = module.s3.bucket_name_final
  depends_on = [ module.vpc, module.s3 ]

}

module "s3" {
  source      = "./modules/s3/"
  region      = var.region

}

