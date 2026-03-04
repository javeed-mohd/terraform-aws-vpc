resource "aws_vpc" "main" {
  cidr_block            = var.vpc_cidr   # It should be user-friendly, user-specific. Users should have freedom to override...
  instance_tenancy      = "default"
  enable_dns_hostnames  = true

  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id # VPC Association

  tags   = local.igw_final_tags
}

# Public Subnets
/* resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs) # 2 public_subnet_cidrs
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index] # 2
  availability_zone = 

  tags = {
    Name = "Main"
  }
} */