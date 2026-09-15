resource "aws_route_table" "myrttable_public" {
  vpc_id = aws_vpc.terraform_project_vpc.id
  
  tags = {
    Name = "terraform-public-rt"
  }
}

resource "aws_route" "myrt_public" {
  route_table_id = aws_route_table.myrttable_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.myigw.id
}

resource "aws_route_table_association" "public_rt_assosciation" {
    count = length(aws_subnet.public)
  route_table_id = aws_route_table.myrttable_public.id
  subnet_id = aws_subnet.public[count.index].id
}

resource "aws_route_table" "myrttable_private" {
  vpc_id = aws_vpc.terraform_project_vpc.id
  tags = {
    Name = "terraform-private-rt"
  }
}

resource "aws_route" "myrt_private" {
  route_table_id = aws_route_table.myrttable_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.mynat.id
}

resource "aws_route_table_association" "private_rt_assosciation" {
    count = length(aws_subnet.private)
  route_table_id = aws_route_table.myrttable_private.id
  subnet_id = aws_subnet.private[count.index].id
}
