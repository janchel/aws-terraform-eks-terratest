variable "name" {
  description = "Name prefix for VPC"
  type        = string
  default     = "demo-eks-vpc"
}

variable "cidr" {
  description = "CIDR for VPC"
  type        = string
  default     = "10.10.0.0/16"
}
