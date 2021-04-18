terraform {

  required_version = "~> 0.12"

}

provider "aws" {

  version = "~> 2.70"

  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

}
