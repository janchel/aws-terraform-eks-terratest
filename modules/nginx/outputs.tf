output "service_lb_hostname" {
  value = try(kubernetes_service.nginx.status[0].load_balancer[0].ingress[0].hostname, "")
}

output "service_lb_ip" {
  value = try(kubernetes_service.nginx.status[0].load_balancer[0].ingress[0].ip, "")
}
