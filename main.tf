module "vpc" {
  source = "./modules/vpc"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  node_key_name   = var.node_key_name
  tags            = var.tags

  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnets
  private_subnet_ids = module.vpc.private_subnets
  depends_on         = [module.vpc]
}

# Write kubeconfig to a local file so kubernetes provider can consume it
resource "local_file" "kubeconfig" {
  content  = module.eks.kubeconfig
  filename = "${path.module}/kubeconfig_${var.cluster_name}.yaml"
}

module "nginx" {
  source = "./modules/nginx"

  namespace = var.nginx_namespace
  replicas  = var.nginx_replicas

  service_annotations = var.nginx_service_annotations

  depends_on = [module.eks]
}
