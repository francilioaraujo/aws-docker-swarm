output "manager_public_ips" {
  value = aws_instance.managers[*].public_ip
}

output "worker_public_ips" {
  value = aws_instance.workers[*].public_ip
}

output "ssh-keyscan" {
  description = "Redirect the stdout of this command to known_hosts file"
  value = "ssh-keyscan -Ht rsa ${join(" ", concat(aws_instance.managers[*].public_ip, aws_instance.workers[*].public_ip))}"
}

output "ssh_config" {
  value = <<-EOT
    %{~ for manager in aws_instance.managers ~}
    Host remote-${manager.tags.Name}
      HostName ${manager.public_ip}
      User ubuntu
      ServerAliveInterval 60
      ServerAliveCountMax
      ControlMaster auto
      ControlPath ~/.ssh/%r@%h:%p.socket
      ControlPersist 10m
    %{~ endfor ~}
  EOT
}