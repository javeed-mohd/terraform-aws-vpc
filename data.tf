# To get aws_availability_zones by default, we use the aws_availability_zones data source
data "aws_availability_zones" "available" {
  state  = "available"
}

# To get aws_vpc by default, we use the aws_vpc data source
data "aws_vpc" "default" {
  default = true
}