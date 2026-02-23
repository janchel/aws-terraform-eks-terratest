variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-northeast-1"
}

provider "aws" {
  region = var.aws_region
}

provider "local" {}

# kubeconfig will be written to a local file and the kubernetes provider will use it
provider "kubernetes" {
  config_path = local_file.kubeconfig.filename
}
