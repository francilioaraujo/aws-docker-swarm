output "manager_public_ips" {
  value = aws_instance.managers.*.public_ip
}

output "worker_public_ip" {
  value = aws_instance.workers.*.public_ip
}