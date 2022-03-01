module "sonarqube-config" {
  # source = "../module-react-microservice"
  source = "git::ssh://git@github.com/OpenCloudCX/module-sonarqube-jenkins-config?ref=demo"

  providers = {
    jenkins   = jenkins,
    sonarqube = sonarqube
  }
}

