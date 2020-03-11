provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform-state-nacha-ras"
    key            = "global/s3/terraform_ras_dev.tfstate"
    region         = "us-east-1"
  }
}
##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################
data "aws_vpc" "selected" {
#  default = true
   id=var.vpc_id #"vpc-02ca5054f172f8a2e"
}


data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.selected.id
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.selected.id
  name   = "default"
}

#####
# DB
#####
module "db" {
  source = "../../"

  identifier = var.db_identifier

  engine            = "postgres"
  engine_version    = "11.5"
  instance_class    = "db.t2.large"
  allocated_storage = 5
  storage_encrypted = false

  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  name = var.dbname

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username = var.dbuser

  password = var.dbuserpassword
  port     = "5432"

  vpc_security_group_ids = [data.aws_security_group.default.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # DB subnet group
  subnet_ids = data.aws_subnet_ids.all.ids

  # DB parameter group
  family = "postgres11"

  # DB option group
  major_engine_version = "11"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = var.dbname

  # Database Deletion Protection
  deletion_protection = false
}


