# Availability Zones
output "azs_info" {
  value       = data.aws_availability_zones.available
  description = "List of available AWS Availability Zones in the current region."
}

# VPC ID 
# This is for 00-vpc in roboshop-infra-dev
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the VPC created."
}

# VPC CIDR
output "vpc_cidr" {
  value       = aws_vpc.main.cidr_block
  description = "CIDR block of the VPC created."
}

# Public Subnet
output "public_subnet_ids" {
  value       = aws_subnet.public[*].id # public[0], public[1]
  # value       = [for subnet in aws_subnet.public : subnet.id]
  description = "List of the Public Subnets IDs."
}

# Private Subnet
output "private_subnet_ids" {
  value       = aws_subnet.private[*].id # private[0], private[1]
  # value       = [for subnet in aws_subnet.private : subnet.id]
  description = "List of the Private Subnets IDs."
}

# Database Subnet
output "database_subnet_ids" {
  value       = aws_subnet.database[*].id # database[0], database[1]
  # value       = [for subnet in aws_subnet.database : subnet.id]
  description = "List of the Database Subnets IDs."    
}

# Internet Gateway
output "igw_id" {
  value       = aws_internet_gateway.main.id
  description = "ID of the Internet Gateway."
}

# NAT Gateway(Network Address Translation)
output "nat_gateway_id" {
  value       = aws_nat_gateway.main.id
  description = "ID of the NAT Gateway."
}

# Elastic IP
output "nat_eip_id" {
  value       = aws_eip.nat.id
  description = "Elastic IP ID associated with the NAT Gateway."
}

# Public Route Table
output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "ID of the Public Route Table."
}

# Private Route Table
output "private_route_table_id" {
  value       = aws_route_table.private.id
  description = "ID of the Private Route Table."
}

# Database Route Table
output "database_route_table_id" {
  value       = aws_route_table.database.id
  description = "ID of the Database Route Table."
}