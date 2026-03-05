# It might not be used all the time in terraform, but used when required...(We can ask user, whether he requires or not)
resource "aws_vpc_peering_connection" "default" {
  count         = var.is_peering_required ? 1 : 0
  # peer_owner_id = var.peer_owner_id
  
  # Accepter -> Accepts the connection
  # To get aws_vpc by default, we use the aws_vpc data source
  peer_vpc_id   = data.aws_vpc.default.id

  # Requester -> Asks for connection
  vpc_id        = aws_vpc.main.id

  auto_accept   = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = merge(
    local.common_tags,
    # roboshop-dev-default
    {
        Name = "${var.project}-${var.environment}-default"
    }
  )
}

# Public Route Table Peering Connection
resource "aws_route" "public_peering" {
  count                     = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.public.id 
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}

# Default Peering Connection
resource "aws_route" "default_peering" {
  count                     = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.default.id 
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}