## access_key
variable "aws_access_key" {}

## secret key
variable "aws_secret_key" {}

## region
variable "aws_region" {}

## aws account reference
data "aws_caller_identity" "current" {}

## prefix
variable "prefix" {}

## environment
variable "env" {}

## api gateway deploy stage name
variable "stage_name" {}
