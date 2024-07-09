resource "aws_instance" "wordpress" {
  ami                         = "ami-0b0dcb5067f052a63" #Amazon Linux 2 AMI com PHP e MariaDB instalado
  instance_type               = "t2.small"
  iam_instance_profile        = "AmazonSSMRoleForInstancesQuickSetup" #IAM Role to attach to the instance
  subnet_id                   = module.network.public_subnets[1]      #Got value from AWS VPC Console from a public subnet
  associate_public_ip_address = true
  #   key_name                    = aws_key_pair.client_msk.id
  vpc_security_group_ids = [aws_security_group.allow_http_in.id]

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "wordpress-prod"
  }
}