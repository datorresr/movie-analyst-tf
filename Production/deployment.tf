resource "kubernetes_namespace" "moviesapp" {
  metadata {
    name = "moviesapp"
  }
//  wait_for_default_service_account = true

}
resource "kubernetes_deployment" "backend" {
  metadata {
    name = "backend-deployment"
    namespace = kubernetes_namespace.moviesapp.metadata[0].name
    labels = {
      app = "backend"
    }
  }

  spec {
    replicas = 4
    selector {
      match_labels = {
        app = "backend"
      }
    }
    template {
      metadata {
        labels = {
          app = "backend"
        }
      }
      spec {
        container {
          name = "movies-api"
          image = "700029235138.dkr.ecr.us-east-1.amazonaws.com/movies-api:latest"
          		  env {
            name = "DB_HOST"
            value = aws_db_instance.MoviesDB.address
          }
          env {
            name = "DB_USER"
            value = aws_db_instance.MoviesDB.username
          }
          env {
            name = "DB_PASS"
            value = aws_db_instance.MoviesDB.password
          }
          

        }
      }
    }
  }
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    namespace = kubernetes_namespace.moviesapp.metadata[0].name
    name = "frontend-deployment"
    labels = {
      app = "frontend"
    }
  }

  spec {
    replicas = 4
    selector {
      match_labels = {
        app = "frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }
      spec {
        container {
          name = "movies-ui"
          image = "700029235138.dkr.ecr.us-east-1.amazonaws.com/movies-ui:latest"
          env {
            name = "BACK_HOST"
            value = kubernetes_service.backend_service.spec[0].cluster_ip
          }
        }
      }
    }
  }
}
