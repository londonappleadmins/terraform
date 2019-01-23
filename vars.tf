provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket  = "grahamgilbert-terraform"
    region  = "us-east-1"
    encrypt = "true"
    key     = "laasite/terraform_state"
  }
}

variable "www_domain_name" {
  default = "www.laa.grahamgilbert.com"
}

variable "root_domain_name" {
  default = "laa.grahamgilbert.com"
}

variable "bucket_name" {
  default = "londonappleadmins"
}
