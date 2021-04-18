# API Gateway
resource "aws_api_gateway_rest_api" "apigw" {

  name = "${var.prefix}-${var.env}-apigw"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# API Gateway Response
resource "aws_api_gateway_gateway_response" "apigw_responce" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  status_code   = "403"
  response_type = "ACCESS_DENIED"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin" = "'*'"

  }
}

# API Gateway Resource
# "/"
data "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  path        = "/"
}

# "items"
resource "aws_api_gateway_resource" "items" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "items"
}

# Method
# GET
resource "aws_api_gateway_method" "items_get" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.items.id
  http_method   = "GET"
  authorization = "AWS_IAM"

  request_parameters = {
    "method.request.querystring.artist" = false
  }
}

resource "aws_api_gateway_integration" "items_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.items.id
  http_method             = aws_api_gateway_method.items_get.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.lambda_function_read.invoke_arn

  content_handling = "CONVERT_TO_TEXT"

  request_templates = {
    "application/json" = <<EOF
#set($inputRoot = $input.path('$'))
{
    "artist": "$input.params('artist')"
}
EOF
  }
}

resource "aws_api_gateway_integration_response" "items_get_integration_responce" {

  depends_on = [
    aws_api_gateway_integration.items_get_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_resource.items.id
  http_method = aws_api_gateway_method.items_get.http_method
  status_code = "200"


  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_method_response" "items_get_method_response" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_resource.items.id
  http_method = aws_api_gateway_method.items_get.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_lambda_permission" "get_invoke_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function_read.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.apigw.execution_arn}/*/GET/items"
}

# POST
resource "aws_api_gateway_method" "items_post" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.items.id
  http_method   = "POST"
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "items_post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.items.id
  http_method             = aws_api_gateway_method.items_post.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.lambda_function_write.invoke_arn

  content_handling = "CONVERT_TO_TEXT"

  request_templates = {
    "application/json" = <<EOF
$input.json('$')
EOF
  }
}

resource "aws_api_gateway_integration_response" "items_post_integration_responce" {

  depends_on = [
    aws_api_gateway_integration.items_post_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_resource.items.id
  http_method = aws_api_gateway_method.items_post.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_method_response" "items_post_method_response" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_resource.items.id
  http_method = aws_api_gateway_method.items_post.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_lambda_permission" "post_invoke_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function_write.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.apigw.execution_arn}/*/POST/items"
}

# OPTIONS
resource "aws_api_gateway_method" "items_options" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.items.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "items_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_resource.items.id
  http_method = aws_api_gateway_method.items_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = <<EOF
{
  "statusCode": 200
}
EOF
  }
}

resource "aws_api_gateway_integration_response" "items_options_integration_responce" {

  depends_on = [
    aws_api_gateway_integration.items_options_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_resource.items.id
  http_method = aws_api_gateway_method.items_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_method_response" "items_options_method_response" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_resource.items.id
  http_method = aws_api_gateway_method.items_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_deployment" "apigw_deploy" {
  depends_on = [
    aws_api_gateway_integration.items_get_integration,
    aws_api_gateway_integration.items_post_integration,
    aws_api_gateway_integration.items_options_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.apigw.id
  stage_name  = var.stage_name

  triggers = {
    ### triggers - (Optional) Map of arbitrary keys and values that, 
    ### when changed, will trigger a redeployment.
    redeployment = "v0.1"

  }
}
