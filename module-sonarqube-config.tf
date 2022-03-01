module "sonarqube-config" {
  # source = "../module-react-microservice"
  source = "git::ssh://git@github.com/OpenCloudCX/module-sonarqube-jenkins-config?ref=demo"

  github_hook_pw    = var.github_hook_pw
  sonarqube_api_key = var.sonarqube_api_key

  providers = {
    jenkins   = jenkins,
    sonarqube = sonarqube
  }
}

