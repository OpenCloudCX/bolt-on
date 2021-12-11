module "python-microservice" {
  # source = "../module-python-microservice"
  source = "git::ssh://git@github.com/OpenCloudCX/module-python-microservice?ref=demo"

  github_hook_pw = var.github_hook_pw

  providers = {
    kubernetes = kubernetes,
    jenkins    = jenkins,
    spinnaker  = spinnaker,
  }
}

