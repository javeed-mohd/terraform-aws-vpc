resource "aws_vpc" "main" {
  cidr_block            = var.vpc_cidr   # It should be user-friendly, user-specific. Users should have freedom to override...
  instance_tenancy      = "default"
  enable_dns_hostnames  = true

  tags = local.vpc_final_tags
}