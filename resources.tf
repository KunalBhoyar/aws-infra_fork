# Create VPC
# terraform aws create vpc
resource "aws_vpc" "kunal" {
  cidr_block = var.vpc-cidr
  # instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = var.res_name
  }
}
