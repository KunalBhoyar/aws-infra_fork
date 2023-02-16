
data "aws_availability_zones" "example" {
  state = "available"
}




# locals {
#   public_zip = zipmap(slice(data.aws_availability_zones.example.names, 1, 4), var.cidr_blk)

# }

locals {
  azs = data.aws_availability_zones.example.names
}




# locals {
#   private_zip = zipmap(slice(data.aws_availability_zones.example.names, 1, 4), var.cidr_blk_pvt)

# }




##Public Subnet Creation

resource "aws_subnet" "public_subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.kunal.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true


  depends_on = [
    aws_vpc.kunal,
    aws_internet_gateway.Internet_Gateway
  ]

  tags = {
    "Name" = "Public subnet"
  }
}



##Private Subnets


resource "aws_subnet" "private_subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.kunal.id
  cidr_block              = "10.0.${count.index + 5}.0/24"
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = false

  depends_on = [
    aws_vpc.kunal,
    aws_internet_gateway.Internet_Gateway
  ]


  tags = {
    "Name" : "Private subnet"
  }
}
























# resource "aws_subnet" "public_subnet" {
#   for_each = local.public_zip


#   cidr_block = each.value
#   vpc_id     = aws_vpc.kunal.id

#   availability_zone = each.key

#   tags = {

#     Name = "Dev Public Subnet ${each.key}"
#   }

#   depends_on = [
#     aws_vpc.kunal
#   ]

# }


# data "aws_subnet_ids" "public" {
#   vpc_id = aws_vpc.kunal.id
#   filter {
#     name   = "tag:Type"
#     values = ["public_subnet"]
#   }
# }














# resource "aws_subnet" "private_subnet" {


#   for_each = local.private_zip

#   cidr_block = each.value

#   vpc_id = aws_vpc.kunal.id

#   availability_zone = each.key

#   map_public_ip_on_launch = false



#   tags = {
#     Name = "Private  Private Subnet ${each.key}"
#   }


#   depends_on = [
#     aws_vpc.kunal
#   ]

# }




