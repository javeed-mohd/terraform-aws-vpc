# Availability Zones
output "azs_info" {
  value       = data.aws_availability_zones.available
  description = "List of available AWS Availability Zones in the current region."
}
