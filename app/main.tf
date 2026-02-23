data "terraform_remote_state" "cluster" {
  backend = "local"

  config = {
    path = "../cluster/terraform.tfstate"
  }
}

module "nginx" {
  source = "../modules/nginx"

  namespace = var.nginx_namespace
  replicas  = var.nginx_replicas

  service_annotations = var.nginx_service_annotations
}
