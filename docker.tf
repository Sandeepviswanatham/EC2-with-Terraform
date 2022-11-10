
#security_group
resource "aws_security_group" "docker" {
  name        = "allow-docker"
  description = "Allow docker inbound traffic"
  vpc_id      ="vpc-01c7b967e5a49ca88"

  ingress {
    description      = "ssh to admin"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
# # ingress {
# #     description      = "for alb end users"
# #     from_port        = 80
# #     to_port          = 80
# #     protocol         = "tcp"
# #     cidr_blocks      = ["0.0.0.0/0"]
# #     #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
#   }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "docker-sg" 
    Terraform = "true"
  }
}
resource "aws_instance" "docker" {
  ami           ="ami-094bbd9e922dc515d"
  instance_type = "t2.micro"
# key_name = "sandeep"
  #vpc_id ="vpc-01c7b967e5a49ca88"
  subnet_id = "subnet-011c46624f581e4be"
  vpc_security_group_ids = [aws_security_group.docker.id]
  key_name = aws_key_pair.sandeep.id
#   subnet_id = "${aws_subnet.private-1b.id}" 
#  user_data = <<EOF
#             #!/bin/bash
#              yum update -y
#              yum install httpd -y 
#              systemctl enable httpd
#              systemctl start httpd
#              mkdir -p  /var/www/html/cricket/
#              echo "this is cricket" >/var/www/html/cricket/index.html
#        EOF
 
  tags = {
    Name = "docker"
  }
}