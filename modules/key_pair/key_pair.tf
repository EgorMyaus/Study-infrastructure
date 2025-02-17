resource "aws_key_pair" "my_key_pair" {
  key_name = var.key_name
  public_key = file("~/.ssh/aws_ec2_ed25519.pub")
}