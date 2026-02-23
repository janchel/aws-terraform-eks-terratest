resource "kubernetes_namespace" "app" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_config_map" "index" {
  metadata {
    name      = "nginx-index"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  data = {
    "index.html" = <<-EOF
    <html>
      <body>
        <h1>Hello World</h1>
      </body>
    </html>
    EOF
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "hello-nginx"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app = "hello-nginx"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "hello-nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "hello-nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:stable"

          port {
            container_port = 80
          }

          volume_mount {
            name       = "www"
            mount_path = "/usr/share/nginx/html"
            read_only  = false
          }
        }

        volume {
          name = "www"

          config_map {
            name = kubernetes_config_map.index.metadata[0].name
            items {
              key  = "index.html"
              path = "index.html"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "hello-nginx-lb"
    namespace = kubernetes_namespace.app.metadata[0].name
    annotations = var.service_annotations
  }

  spec {
    selector = {
      app = "hello-nginx"
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }
}
