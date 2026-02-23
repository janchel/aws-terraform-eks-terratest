variable "namespace" {
  description = "Kubernetes namespace to deploy into"
  type        = string
  default     = "hello-nginx"
}

variable "replicas" {
  description = "Number of nginx replicas"
  type        = number
  default     = 2
}

variable "service_annotations" {
  description = "Annotations to add to the Service resource (for AWS LB behavior)"
  type        = map(string)
  default     = {
    # By default this leaves provider to choose load balancer type. If you want ALB via AWS Load Balancer Controller,
    # you'll need to install that controller and use an Ingress instead.
  }
}
