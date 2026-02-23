output "kubeconfig_file" {
  description = "Path to the generated kubeconfig file"
  value       = local_file.kubeconfig.filename
}

output "nginx_lb_hostname" {
  value = module.nginx.service_lb_hostname
}

output "nginx_lb_ip" {
  value = module.nginx.service_lb_ip
}
