output "moviesDB_address" {
  value = aws_db_instance.MoviesDB.address
  sensitive = true
}
output "moviesDB_username" {
  value = aws_db_instance.MoviesDB.username
  sensitive = true
}
output "moviesDB_password" {
  value = aws_db_instance.MoviesDB.password
  sensitive = true
}
