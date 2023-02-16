



### AWS Route Table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.kunal.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet_Gateway.id
  }

  tags = {
    "Name" = "public route table "
  }
}



##associating public Route Table with subnet

resource "aws_route_table_association" "public" {
  count          = 3
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}



##associating private Route Table with subnet

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.kunal.id

  tags = {
    "Name" = "private route table"
  }
}



resource "aws_route_table_association" "private" {
  count          = 3
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route.id
}

