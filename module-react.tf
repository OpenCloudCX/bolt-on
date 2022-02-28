module "react-microservice" {
  # source = "../module-react-microservice"
  source = "git::ssh://git@github.com/OpenCloudCX/module-react-microservice?ref=develop"

  github_hook_pw = var.github_hook_pw

  providers = {
    kubernetes = kubernetes,
    jenkins    = jenkins,
    spinnaker  = spinnaker,
  }
}

