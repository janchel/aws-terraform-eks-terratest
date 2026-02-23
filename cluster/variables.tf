variable "cluster_name" {
  description = "Name for the EKS cluster"
  type        = string
  default     = "demo-eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for EKS"
  type        = string
  default     = "1.33"
}

variable "node_key_name" {
  description = "SSH key name to attach to worker nodes (optional)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to AWS resources"
  type        = map(string)
  default     = {}
}

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
  description = "Annotations for the nginx Service (e.g., aws-load-balancer-type)"
  type        = map(string)
  default     = {}
}
