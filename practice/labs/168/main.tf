module "network" {
  source = "./modules/network"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "security_group_id" {
  value = module.security.security_group_id
}
