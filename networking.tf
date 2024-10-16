provider "aws" {
  region     = "us-east-1" # Cambia esto según tu región preferida
  access_key = ""
  secret_key = ""
}

# Crear VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "my-vpc"
  }
}

# Crear subredes públicas
resource "aws_subnet" "my_subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet-a"
  }
}

resource "aws_subnet" "my_subnet_b" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet-b"
  }
}

# Crear subredes privadas
resource "aws_subnet" "my_private_subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "my-private-subnet-a"
  }
}

resource "aws_subnet" "my_private_subnet_b" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "my-private-subnet-b"
  }
}

# Crear Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-igw"
  }
}

# Crear tabla de enrutamiento para las subredes públicas
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-route-table"
  }
}

# Rutas para acceso a Internet desde las subredes públicas
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Asociar la tabla de enrutamiento con las subredes públicas
resource "aws_route_table_association" "subnet_a_association" {
  subnet_id      = aws_subnet.my_subnet_a.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "subnet_b_association" {
  subnet_id      = aws_subnet.my_subnet_b.id
  route_table_id = aws_route_table.my_route_table.id
}

# Crear tabla de enrutamiento para subredes privadas (sin acceso a Internet)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "private-route-table"
  }
}

# Asociar la tabla de enrutamiento con las subredes privadas
resource "aws_route_table_association" "private_subnet_a_association" {
  subnet_id      = aws_subnet.my_private_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_b_association" {
  subnet_id      = aws_subnet.my_private_subnet_b.id
  route_table_id = aws_route_table.private_route_table.id
}
