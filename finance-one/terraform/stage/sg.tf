resource "aws_security_group" "allow_mariadb" {
  name        = "allow_mariadb"
  description = "Allow MariaDB inbound traffic"
  vpc_id      = module.network.vpc_id

  ingress {
    description      = "MariaDB Conn from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_mariadb"
  }
}

resource "aws_security_group" "allow_http_in" {
  name        = "allow_http_in"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.network.vpc_id

  ingress {
    description      = "HTTP conn public"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTPS conn public"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http_in"
  }
}

# resource "aws_security_group" "allow_https_in" {
#   name        = "allow_https_in"
#   description = "Allow HTTPS inbound traffic"
#   vpc_id      = module.network.vpc_id

#   ingress {
#     description      = "HTTPS conn public"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "allow_https_in"
#   }
# }