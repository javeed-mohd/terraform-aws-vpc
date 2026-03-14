# Data sources are used to query and fetch existing information from your provider like AWS, so you can use that data in your Terraform configuration.
# To get aws_availability_zones by default, we use the aws_availability_zones data source
data "aws_availability_zones" "available" {
  state  = "available"
}

# To get aws_vpc by default, we use the aws_vpc data source
data "aws_vpc" "default" {
  default = true
}

# To get aws_route_table by default, we use the aws_route_table data source
data "aws_route_table" "default" {
  vpc_id   = data.aws_vpc.default.id 
  filter {
    name   = "association.main"
    values = ["true"]
  }
}