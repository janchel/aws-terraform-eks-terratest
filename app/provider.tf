data "terraform_remote_state" "cluster" {
  backend = "local"

  config = {
    path = "../cluster/terraform.tfstate"
  }
}

provider "kubernetes" {
  config_path = data.terraform_remote_state.cluster.outputs.kubeconfig_file
}
