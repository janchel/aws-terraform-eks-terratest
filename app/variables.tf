variable "nginx_namespace" {
  description = "Namespace for the nginx app"
  type        = string
  default     = "hello-nginx"
}

variable "nginx_replicas" {
  description = "Number of nginx replicas"
  type        = number
  default     = 2
}

variable "nginx_service_annotations" {
  description = "Annotations for the nginx Service"
  type        = map(string)
  default     = {}
}
