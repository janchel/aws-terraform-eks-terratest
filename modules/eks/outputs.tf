output "cluster_id" {
  value = module.this_eks.cluster_id
}

output "cluster_endpoint" {
  value = module.this_eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.this_eks.cluster_certificate_authority_data
}

output "kubeconfig" {
  value = local.kubeconfig
}
