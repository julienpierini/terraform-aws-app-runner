locals {
    tags = {
        Environment = "dev"
        Project     = "sandbox"
        stack       = "app-runner"
        Deployer    = "terraform"
  }
}

module "app-runner" {
    source = "../..//"

    app_runner = {
        "httpbin" = {
            enable_vpc_egress_configuration = true
            enabled_auto_deployments        = local.httpbin_enabled_auto_deployments
            kms_key_arn                     = module.kms.outputs.key_arn

            image_repository_type = "ECR"
            image_identifier      = "${module.ecr.outputs.repository_url}:v0.1.0"

            vpc_id       = module.vpc.outputs.vpc_id
            subnets      = module.vpc.outputs.private_subnets

            auto_scaling_configuration = {
                max_concurrency = 100
                max_size        = 2
                min_size        = 1
                tags            = local.tags
            }
            image_configuration = {
                port = 80
            }
            instance_configuration = {
                cpu    = 1024
                memory = 2048
            }

            tags = local.tags
        }
    }
}
