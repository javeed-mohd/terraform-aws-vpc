resource "aws_vpc" "main" {
  cidr_block            = var.vpc_cidr   # It should be user-friendly, user-specific. Users should have freedom to override...
  instance_tenancy      = "default"
  enable_dns_hostnames  = true # By default it is false, to enable we use true orelse we won't mention(To enable dns hostnames)...

  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id # VPC Association

  tags   = local.igw_final_tags
}

# Public Subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs) # 2 public_subnet_cidrs
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index] # 2
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true # By default it is false, to enable we use true orelse we won't mention(To enable public ip).

  tags = merge(
    local.common_tags,
    # roboshop-dev-public-us-east-1a, roboshop-dev-public-us-east-1b
    {
      Name  = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
    },
    var.public_subnet_tags # For users
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)  # 2 private_subnet_cidrs
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index] # 2
  availability_zone = local.az_names[count.index]
  # map_public_ip_on_launch = true # By default it is false, to enable we use true orelse we won't mention(To enable public ip).

  tags = merge(
    local.common_tags,
    # roboshop-dev-private_us-east-1a, roboshop-dev-private_us-east-1b
    {
      Name  = "${var.project}-${var.environment}-private-${local.az_names[count.index]}"
    },
    var.private_subnet_tags # For users
  )
}

# Database Subnets
resource "aws_subnet" "database" {
  count             = length(var.database_subnet_cidrs) # 2 database_subnet_cidrs
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_cidrs[count.index] # 2
  availability_zone = local.az_names[count.index]
  # map_public_ip_on_launch = true # By default it is false, to enable we use true orelse we won't mention(To enable public ip).

  tags = merge(
    local.common_tags,
    # roboshop-dev-database-us-east-1a, roboshop-dev-database-us-east-1b
    {
      Name  = "${var.project}-${var.environment}-database-${local.az_names[count.index]}"
    },
    var.database_subnet_tags # For users
  )
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    # roboshop-dev-public
    {
      Name  = "${var.project}-${var.environment}-public"
    },
    var.public_route_table_tags # For users
  )
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    # roboshop-dev-private
    {
      Name  = "${var.project}-${var.environment}-private"
    },
    var.private_route_table_tags # For users
  )
}

# Database Route Table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    # roboshop-dev-database
    {
      Name  = "${var.project}-${var.environment}-database"
    },
    var.database_route_table_tags # For users
  )
}

# Public Route Table(Internet Gateway)
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.main.id
}

# Elastic IP Creation
resource "aws_eip" "nat" {
  domain                    = "vpc"

  tags  = merge(
    local.common_tags,
    {
      Name  = "${var.project}-${var.environment}-nat"
    },
    var.eip_tags
  )
}

# AWS NAT-Gateway
# To create NAT Gateway, we need Elastic IP which is a static IP which does not change after start/stop of the instance...
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id # We are creating this in us-east-1a AZ i.e., public[0] (public[1] -> us-east-1b)

  tags = merge(
    local.common_tags,
    {
      Name  = "${var.project}-${var.environment}"
    },
    var.nat_gateway_tags
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main] # We have to add it explicitly to connect internet gateway through nat gateway...
}

# Private Route Table(NAT Gateway -> Outgoing traffic)
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id # 0.0.0.0/0 NAT -> NAT(Network Address Translation) Gateway to connect public subnet internally.
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.main.id # Specific for NAT Gateway
}

# Database Route Table(NAT Gateway -> Outgoing traffic)
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id # 0.0.0.0/0 NAT -> NAT(Network Address Translation) Gateway to connect public subnet internally.
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.main.id # Specific for NAT Gateway
}

# Public Route Table Association
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id # Public[0], Public[1]
  route_table_id = aws_route_table.public.id
}

# Private Route Table Association
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id # Private[0], Private[1]
  route_table_id = aws_route_table.private.id
}

# Database Route Table Association
resource "aws_route_table_association" "database" {
  count          = length(var.database_subnet_cidrs)
  subnet_id      = aws_subnet.database[count.index].id # Database[0], Database[1]
  route_table_id = aws_route_table.database.id
}