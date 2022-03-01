terraform {
  required_providers {
    jenkins = {
      source  = "taiidani/jenkins"
      version = "~> 0.9.0"
    }
    spinnaker = {
      source  = "tidal-engineering/spinnaker"
      version = "1.0.6"
    }
    sonarqube = {
      source  = "jdamata/sonarqube"
      version = "0.0.11"
    }
  }
}

provider "kubernetes" {
  host                   = var.eks_host
  token                  = var.eks_token
  cluster_ca_certificate = var.cluster_ca_certificate
}

provider "jenkins" {
  server_url = "http://${var.jenkins_host}.${var.dns_zone}"
  username   = "admin"
  password   = var.jenkins_pw
}

provider "spinnaker" {
  server             = "http://${var.spinnaker_host}.${var.dns_zone}"
  ignore_cert_errors = true
}

provider "sonarqube" {
  host                     = "http://sonarqube.${var.dns_zone}"
  user                     = "admin"
  pass                     = var.sonarqube_pw
  tls_insecure_skip_verify = true
}


