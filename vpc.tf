resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MY_VPC"
  }
}


#Create your application segment
resource "aws_subnet" "my_app-subnet" {
  tags = {
    Name = "APP_Subnet"
  }
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  depends_on              = [aws_vpc.my_vpc]

}


#Define routing table
resource "aws_route_table" "my_route-table" {
  tags = {
    Name = "MY_Route_table"

  }
  vpc_id = aws_vpc.my_vpc.id
}


#Associate subnet with routing table
resource "aws_route_table_association" "App_Route_Association" {
  subnet_id      = aws_subnet.my_app-subnet.id
  route_table_id = aws_route_table.my_route-table.id
}




#Create internet gateway for servers to be connected to internet
resource "aws_internet_gateway" "my_IG" {
  tags = {
    Name = "MY_IGW"
  }
  vpc_id     = aws_vpc.my_vpc.id
  depends_on = [aws_vpc.my_vpc]
}


#Add default route in routing table to point to Internet Gateway
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.my_route-table.id
  destination_cidr_block = "0.0.0.0/0"


  gateway_id = aws_internet_gateway.my_IG.id

}
