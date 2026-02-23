output "kubeconfig_file" {
  description = "Path to the generated kubeconfig file"
  value       = local_file.kubeconfig.filename
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}
