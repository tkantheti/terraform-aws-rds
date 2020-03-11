
variable "vpc_id"{
  description = "VPC ID "
}

variable "db_identifier"{
  description = "Database name"
  default     = "ras-postgres"
}
variable "dbname" {
  description = "Database name"
  default     = "rasdb"
}
variable "dbuser" {
  description = "Database user"
  default     = "rasuser"
}
variable "dbuserpassword" {
  description = "db pwd"
  default     = "YourPwdShouldBeLongAndSecure!"
}
