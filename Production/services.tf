resource "kubernetes_service" "backend_service" {
  metadata {
    name = "backend-service"
    //namespace = kubernetes_namespace.moviesapp.metadata[0].name
  }

  spec {
    selector = {
      app = "backend"
    }

    port {
      port        = 3000
      target_port = 3000
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "frontend_service" {
  metadata {
    name = "frontend-service"
    //namespace = kubernetes_namespace.moviesapp.metadata[0].name
  }

  spec {
    selector = {
      app = "frontend"
    }

    port {
      port        = 80
      target_port = 3030
    }

    type = "LoadBalancer"
  }
}
