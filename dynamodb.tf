resource "aws_dynamodb_table" "dynamodb_table" {

  name = "${var.prefix}-${var.env}-table"

  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "Artist"
  range_key      = "Title"

  attribute {
    name = "Artist"
    type = "S"
  }

  attribute {
    name = "Title"
    type = "S"
  }
}
