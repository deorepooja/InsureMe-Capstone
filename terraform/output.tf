output "instance_public_ip" {
  description = "Public IP of the InsureMe EC2 node"
  value       = aws_instance.insureme_node.public_ip
}

output "vpc_id" {
  value = aws_vpc.insureme_vpc.id
}

output "subnet_id" {
  value = aws_subnet.insureme_subnet.id
}
