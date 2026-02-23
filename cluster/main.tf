data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../vpc/terraform.tfstate"
  }
}

module "eks" {
  source = "../modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  node_key_name   = var.node_key_name
  tags            = var.tags

  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnet_ids  = data.terraform_remote_state.vpc.outputs.public_subnets
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
}

# Write kubeconfig to a local file so the `app` folder can use it via terraform_remote_state
resource "local_file" "kubeconfig" {
  content  = module.eks.kubeconfig
  filename = "${path.module}/kubeconfig_${var.cluster_name}.yaml"
}
