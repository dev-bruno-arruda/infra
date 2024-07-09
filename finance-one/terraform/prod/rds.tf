resource "aws_db_instance" "financeone" {
  identifier             = "financeone-prod"
  db_name                = "financeoneb"
  engine                 = "mariadb"
  engine_version         = "10.3.34"
  instance_class         = "db.t3.micro"
  username               = "financeoneb"
  password               = "cbRFkCR6cV2c3TJ"
  option_group_name      = "default:mariadb-10-3"
  parameter_group_name   = "default.mariadb10.3"
  db_subnet_group_name   = "financeone-prod-subnets-vpc-08c6c16c484520d39"
  vpc_security_group_ids = [aws_security_group.allow_mariadb.id]
  skip_final_snapshot    = true
  maintenance_window     = "mon:04:00-mon:05:00"
  backup_window          = "05:30-06:00"
  copy_tags_to_snapshot  = true

  ca_cert_identifier  = "rds-ca-2019"
  port                = 3306
  publicly_accessible = true

  allocated_storage     = 100
  max_allocated_storage = 150

  monitoring_interval = 60
  monitoring_role_arn = "arn:aws:iam::186267377292:role/rds-monitoring-role"

  multi_az = false

  performance_insights_enabled = false

}