


# Create VPC
# terraform aws create vpc


resource "aws_vpc" "kunal" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  # instance_tenancy     = "default"


  tags = {
    "Name" = var.vpc_name
  }
}