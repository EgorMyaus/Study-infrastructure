variable "allowed_ssh_ip" {
  description = "Allowed SSH IP CIDR (modify for security)"
  type = list(string)
  default = ["94.63.118.183/32"]
}