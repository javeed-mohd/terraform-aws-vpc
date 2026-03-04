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
  map_public_ip_on_launch = true # By default it is false, to enable we use true orelse we won't mention(To enable public ip...

  tags = merge(
    local.common_tags,
    # roboshop-dev-public-us-east-1a, roboshop-dev-public-us-east-1b
    {
      Name  = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
    },
    var.public_subnet_tags
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)  # 2 public_subnet_cidrs
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index] # 2
  availability_zone = local.az_names[count.index]
  
  tags = merge(
    local.common_tags,
    # roboshop-dev-private_us-east-1a, roboshop-dev-private_us-east-1b
    {
      Name  = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
    },
    var.private_subnet_tags
  )
}

# Database Subnets
resource "aws_subnet" "database" {
  count             = length(var.database_subnet_cidrs) # 2 public_subnet_cidrs
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_cidrs[count.index] # 2
  availability_zone = local.az_names[count.index]

  tags = merge(
    local.common_tags,
    # roboshop-dev-database-us-east-1a, roboshop-dev-database-us-east-1b
    {
      Name  = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
    },
    var.database_subnet_tags
  )
}