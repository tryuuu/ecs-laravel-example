resource "aws_db_subnet_group" "example_db_subnet_group" {
  name       = "my-db-subnet-group"
  #rdsはプライベートサブネット
  subnet_ids = [aws_subnet.example_private_subnet_1.id, aws_subnet.example_private_subnet_2.id]

  tags = {
    Name = "My DB Subnet Group"
  }
}

resource "aws_db_instance" "example_rds" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = ""
  username             = ""
  password             = ""
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.example_rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.example_db_subnet_group.name
}

