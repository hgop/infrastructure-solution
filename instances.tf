resource "aws_instance" "microk8s" {
  ami           = "ami-0885b1f6bd170450c" # Ubuntu 20.04
  instance_type = "t3.medium"
  key_name      = "MicroK8s"

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.microk8s_security_group.id
  ]

  tags = {
    Name = "MicroK8s"
  }
}

output "microk8s_dns" {
  value = aws_instance.microk8s.public_dns
}
