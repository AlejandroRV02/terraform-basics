terraform {
  backend "s3" {
	bucket = "devops-directive-tf-state"
	key = "terraform-basics/web-app/terraform.tfstate"
	region = "us-east-1"
	dynamodb_table = "terraform-state-locking"
	encrypt = true
  }

  required_providers {
	aws = {
		source = "hashicorp/aws"
		version = "~> 3.0"
	}
  }
}

provider "aws" {
  region = "us-east-1"
}

#Local variables
locals {
	extra_tag = "extra-tag"
}

resource "aws_instance" "instance" {
  	#ami = "ami-011899242bb902164"
  	ami = var.ami
  
  	#instance_type = "t2.micro"
  	instance_type = var.instance_type
  
  	tags = {
		Name = var.instance_name
		ExtraTag = local.extra_tag
  	}
}

resource "aws_db_instance" "db_instance" {
	allocated_storage 	= 20
	storage_type 			= "gp2"
	engine 					= "postgres"
	engine_version 		= "12.5"
	instance_class 		= "db.t2.micro"
	db_name 						= "webappdb"
	username 				= var.db_user
	password 				= var.db_password
	skip_final_snapshot 	= true
}
