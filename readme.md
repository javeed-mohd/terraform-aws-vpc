## Terraform AWS VPC Module

A Terraform module for provisioning a production-ready AWS VPC with public, private, and database subnet tiers, Internet Gateway, NAT Gateway, and Route Tables.

## Usage

```hcl
module "vpc" {
  source = "git::https://github.com/javeed-mohd/terraform-aws-vpc.git?ref=main"

  project     = "roboshop"
  environment = "dev"

  vpc_cidr = "10.0.0.0/16"

  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs  = ["10.0.11.0/24", "10.0.12.0/24"]
  database_subnet_cidrs = ["10.0.21.0/24", "10.0.22.0/24"]

  is_peering_required = false
}
```


## Features

* VPC with configurable CIDR block and DNS hostname support.
* Public, Private, and Database subnet tiers across multiple Availability Zones.
* Internet Gateway for public subnets.
* NAT Gateway (with Elastic IP) for private and database subnet outbound access.
* Separate route tables for each subnet tier.
* Optional VPC peering support flag.
* Fully customizable tags on every resource.*
