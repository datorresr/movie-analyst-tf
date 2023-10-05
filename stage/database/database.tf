resource "aws_db_subnet_group" "movies_RDS_SNG" {
  name       = "main"
  subnet_ids = [data.terraform_remote_state.network.outputs.subnet_PriBE1_id, data.terraform_remote_state.network.outputs.subnet_PriBE2_id]
}

resource "aws_db_instance" "MoviesDB" {
  engine               = "mysql"
  identifier           = "moviesdb"
  allocated_storage    =  20
  engine_version       = "8.0.33"
  instance_class       = "db.t3.micro"
  username             = "applicationuser"
  password             = "applicationuser"
  parameter_group_name = "default.mysql8.0"
  ca_cert_identifier = "rds-ca-rsa2048-g1"
  db_subnet_group_name      = "${aws_db_subnet_group.movies_RDS_SNG.id}"
  availability_zone = "us-east-1a"
  db_name = "movie_db"
  vpc_security_group_ids = ["${data.terraform_remote_state.network.outputs.SG_RDS_id}"]
  skip_final_snapshot  = true
  publicly_accessible =  false
}

resource "null_resource" "execute_sql" {
  depends_on = [aws_db_instance.MoviesDB]

  triggers = {
    instance_id = aws_db_instance.MoviesDB.id
  }
  provisioner "local-exec" {
    command = "mysql -h ${aws_db_instance.MoviesDB.address} -P ${aws_db_instance.MoviesDB.port} -u ${aws_db_instance.MoviesDB.username} -p${aws_db_instance.MoviesDB.password} < table_creation.sql"
  }
}