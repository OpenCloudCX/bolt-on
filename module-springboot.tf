module "springboot-microservice" {
  source = "../module-springboot-microservice"
  # source = "git::ssh://git@github.com/OpenCloudCX/module-springboot-microservice?ref=develop"

  github_hook_pw = var.github_hook_pw

  providers = {
    kubernetes = kubernetes,
    jenkins    = jenkins,
    spinnaker  = spinnaker,
  }
}

