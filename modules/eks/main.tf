module "this_eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # Enable public access for kubectl from local machine
  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = true

  # Provide the VPC and subnet IDs from the root VPC module
  vpc_id     = var.vpc_id
  subnet_ids = length(var.private_subnet_ids) > 0 ? var.private_subnet_ids : null

  # v20 uses different aws-auth handling
  # manage_aws_auth_configmap = false  # Removed in v20

  # v20 uses 'eks_managed_node_groups' for managed node groups
  eks_managed_node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t3.medium"]
      key_name         = var.node_key_name != "" ? var.node_key_name : null
      associate_public_ip_address = false
    }
  }

  eks_managed_node_group_defaults = {
    associate_public_ip_address = false
  }

  access_entries = {
    "peter" = {
      principal_arn     = "arn:aws:iam::238720143265:user/peter"
      type              = "STANDARD"
      username          = "peter"
      kubernetes_groups = ["system:masters"]
    }
  }

  tags = var.tags
}

locals {
  kubeconfig = yamlencode({
    apiVersion = "v1"
    clusters = [{
      cluster = {
        certificate-authority-data = module.this_eks.cluster_certificate_authority_data
        server                     = module.this_eks.cluster_endpoint
      }
      name = var.cluster_name
    }]
    contexts = [{
      context = {
        cluster = var.cluster_name
        user    = var.cluster_name
      }
      name = var.cluster_name
    }]
    current-context = var.cluster_name
    kind            = "Config"
    preferences     = {}
    users = [{
      name = var.cluster_name
      user = {
        exec = {
          apiVersion = "client.authentication.k8s.io/v1beta1"
          args       = ["eks", "get-token", "--cluster-name", var.cluster_name]
          command    = "aws"
        }
      }
    }]
  })
}
