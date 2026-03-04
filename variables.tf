# Users can override this accordingly.
variable "project" {
  type      = string
}

variable "environment" {
  type      = string
}

variable "vpc_cidr" {
  type      = string
  default   = "10.0.0.0/16"
}

# Empty means Optional (Users can pass tags). If values provided, it can be overridden...
variable "vpc_tags" {
  type        = map
  default     = {}
}