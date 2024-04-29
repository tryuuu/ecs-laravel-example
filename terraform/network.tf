resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc"
  }
}
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "example-igw"
  }
}
#NAT gatewayないので外からrdsにアクセスはできない
resource "aws_subnet" "example_public_subnet_1" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "example-public-subnet-1"
  }
}
resource "aws_subnet" "example_public_subnet_2" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "example-public-subnet-2"
  }
}

resource "aws_subnet" "example_private_subnet_1" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "example-private-subnet-1"
  }
}

resource "aws_subnet" "example_private_subnet_2" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "example-private-subnet-2"
  }
}
resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id #Internet Gateway経由
  }

  tags = {
    Name = "example-route-table"
  }
}
resource "aws_route_table_association" "example_rta_public_1" {
  subnet_id      = aws_subnet.example_public_subnet_1.id
  route_table_id = aws_route_table.example_route_table.id
}

resource "aws_route_table_association" "example_rta_public_2" {
  subnet_id      = aws_subnet.example_public_subnet_2.id
  route_table_id = aws_route_table.example_route_table.id
}
