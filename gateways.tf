


# Create an internet gateway

resource "aws_internet_gateway" "Internet_Gateway" {
  vpc_id = aws_vpc.kunal.id


  depends_on = [
    aws_vpc.kunal
  ]

  tags = {
    Name = "Public_Internet_gateway"
  }



}








