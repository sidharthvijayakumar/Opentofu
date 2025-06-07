#Output.tf without for_each
# output "ec2_instance_id" {
#   value = module.ec2_instance.id
# }

# output "ec2_public_ip" {
#   value = module.ec2_instance.public_ip
# }

# output "ec2_private_ip" {
#   value = module.ec2_instance.private_ip
# }

########################
#For_each
########################

# output "instance_ids" {
#   description = "Map of instance IDs"
#   value = {
#     for k, m in module.ec2_instance : k => m.id
#   }
# }

# output "public_ips" {
#   description = "Map of public IPs"
#   value = {
#     for k, m in module.ec2_instance : k => m.public_ip
#   }
# }