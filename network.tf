resource "aws_vpc" "edr_wg_vpc" {
  cidr_block           = var.base_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "${var.env_prefix}_vpc"
  }
}

resource "aws_subnet" "edr_wg_public_subnet" {
  vpc_id                  = aws_vpc.edr_wg_vpc.id
  cidr_block              = cidrsubnet(var.base_cidr_block, 8, 1)
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.env_prefix}_public_subnet"
  }
}

resource "aws_internet_gateway" "edr_wg_igw" {
  vpc_id = aws_vpc.edr_wg_vpc.id

  tags = {
    "Name" = "${var.env_prefix}_vpc_igw"
  }

}

resource "aws_route_table" "edr_wg_public_subnet_rt" {
  vpc_id = aws_vpc.edr_wg_vpc.id
  tags = {
    "Name" = "${var.env_prefix}_public_subnet_rt"
  }
}

resource "aws_route" "edr_wg_public_subnet_route" {
  route_table_id         = aws_route_table.edr_wg_public_subnet_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.edr_wg_igw.id
}

resource "aws_route_table_association" "edr_wg_route_assoc" {
  subnet_id      = aws_subnet.edr_wg_public_subnet.id
  route_table_id = aws_route_table.edr_wg_public_subnet_rt.id
}

