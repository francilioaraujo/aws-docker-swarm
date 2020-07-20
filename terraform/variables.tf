variable "base_ami_id" {
  type        = string
  description = "AMI ID to use for instances"
  default     = "ami-02ae530dacc099fc9"
}

variable "my_public_key_file" {
  type        = string
  description = "The path of my public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "n_managers" {
  type        = number
  description = "Number of manager nodes to create"
  default     = 1
}

variable "n_workers" {
  type        = number
  description = "Number of worker nodes to create"
  default     = 2
}
