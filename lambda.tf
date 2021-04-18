# Lambda (DynamoDB Rread)
data "archive_file" "source_code_read" {
  type        = "zip"
  source_file = "./src/read/index.js"
  output_path = "./dist/read.zip"
}

resource "aws_lambda_function" "lambda_function_read" {
  function_name    = "${var.prefix}-${var.env}-lambda-read"
  role             = aws_iam_role.iam_role_lambda.arn
  runtime          = "nodejs12.x"
  handler          = "index.handler"
  timeout          = 10
  filename         = data.archive_file.source_code_read.output_path
  source_code_hash = data.archive_file.source_code_read.output_base64sha256

  environment {
    variables = {
      table_name = aws_dynamodb_table.dynamodb_table.name
    }
  }

}

# Lambda (DynamoDB Write)
data "archive_file" "source_code_write" {
  type        = "zip"
  source_file = "./src/write/index.js"
  output_path = "./dist/write.zip"
}

resource "aws_lambda_function" "lambda_function_write" {
  function_name    = "${var.prefix}-${var.env}-lambda-write"
  role             = aws_iam_role.iam_role_lambda.arn
  runtime          = "nodejs12.x"
  handler          = "index.handler"
  timeout          = 10
  filename         = data.archive_file.source_code_write.output_path
  source_code_hash = data.archive_file.source_code_write.output_base64sha256

  environment {
    variables = {
      table_name = aws_dynamodb_table.dynamodb_table.name
    }
  }

}




