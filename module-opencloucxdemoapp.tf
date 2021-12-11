module "opencloudcxdemoapp" {
  # source = "../module-python-microservice"
  source = "git::ssh://git@github.com/OpenCloudCX/module-bootstrapdemoapp?ref=demo"

  github_hook_pw = var.github_hook_pw

  providers = {
    kubernetes = kubernetes,
    jenkins    = jenkins,
    spinnaker  = spinnaker,
  }
}

