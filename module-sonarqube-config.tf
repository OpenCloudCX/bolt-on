module "sonarqube-config" {
  # source = "../module-react-microservice"
  source = "git::ssh://git@github.com/OpenCloudCX/module-sonarqube-jenkins-config?ref=demo"

  github_hook_pw = var.github_hook_pw

  providers = {
    jenkins = jenkins
  }
}

