output "intance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.tfletcher_web.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.tfletcher_web.public_ip
}


