output "subnets_idss" {
  value = lookup(module.vpc, "main",null)
}