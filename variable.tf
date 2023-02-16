# # VPC Variables
# variable "region" {
#   default     = "us-east-1"
#   description = "AWS Region"
#   type        = string
# }



variable "vpc_name" {
  type = string

  description = "Virtual cloud name"
}




variable "profile" {
  type = string

  description = "Profile across which Cloud Operation To Be performed"
}




variable "inst_region" {
  type        = string
  description = "Installation Region"
}




variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC CIDR Block"
  type        = string
}








# variable "res_name" {

#   type = string

#   # default = "kb"


# }


# variable "region" {

#   type    = string
#   default = "us-east-1"
# }



# variable "cidr_blk" {
#   type    = list(string)
#   default = ["10.0.192.0/19", "10.0.240.0/21", "10.0.252.0/23"]

#   # default = ["255.255.0.0/16", "255.178.0.0/16", "255.170.0.0/16"]
# }


# variable "cidr_blk_pvt" {
#   type    = list(string)
#   default = ["10.0.254.128/25", "10.0.255.128/26", "10.0.255.192/26"]

#   # default = ["255.255.0.0/16", "255.178.0.0/16", "255.170.0.0/16"]
# }


