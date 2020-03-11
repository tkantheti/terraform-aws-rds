
variable "vpc_id"{
  description = "VPC ID "
  default="vpc-02ca5054f172f8a2e"
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
