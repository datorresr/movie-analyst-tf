//resource "kubernetes_namespace" "moviesapp" {
//  metadata {
//    name = "moviesapp"
//  }
//  wait_for_default_service_account = true

//}

//resource "kubernetes_service_account" "my-service-account" {
//  metadata {
//    name = "my-service-account"
//    namespace = kubernetes_namespace.moviesapp.metadata[0].name
//  }
//}

//resource "kubernetes_role_binding" "my-cluster-admin-rolebinding" {
//  role_ref {
//    api_group = "rbac.authorization.k8s.io"
//    kind = "ClusterRole"
//    name = "cluster-admin"
//  }
//  metadata {
 //   name      = "k8srolebinding"
//   namespace = kubernetes_namespace.moviesapp.metadata[0].name
 // }
//  subject {
//    kind = "ServiceAccount"
//    name = "my-service-account"
//    namespace = kubernetes_namespace.moviesapp.metadata[0].name
//
//  }
//}

//resource "kubernetes_config_map" "my-config-map" {
//  metadata {
//    name = "my-config-map"
//    namespace = kubernetes_namespace.moviesapp.metadata[0].name
//  }
//  data = {
//    "kubeconfig" = "${file("~/.kube/config")}"
//  }
//}

resource "kubernetes_deployment" "backend" {
  metadata {
    name = "backend-deployment"
    //namespace = kubernetes_namespace.moviesapp.metadata[0].name
    labels = {
      app = "backend"
    }
  }

  spec {
    replicas = 2
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
        //service_account_name = "my-service-account"
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
    //namespace = kubernetes_namespace.moviesapp.metadata[0].name
    name = "frontend-deployment"
    labels = {
      app = "frontend"
    }
  }

  spec {
    replicas = 2
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
        //service_account_name = "my-service-account"
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
