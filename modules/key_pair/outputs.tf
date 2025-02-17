output "key_pair_name" {
  description = "Name of the key pair"
  value       = aws_key_pair.my_key_pair.key_name
}