# IAM Role for Lambda
resource "aws_iam_role" "iam_role_lambda" {
  name               = "${var.prefix}-${var.env}-lambda-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}  
 EOF
}

resource "aws_iam_policy" "lambda-policy" {
  name   = "${var.prefix}-${var.env}-lambda-policy"
  policy = file("./iam-policy/lambda_policy.json")
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  policy_arn = aws_iam_policy.lambda-policy.arn
  role       = aws_iam_role.iam_role_lambda.name
}

resource "aws_iam_role_policy_attachment" "aws_lambda_exec_policy_attach" {
  role       = aws_iam_role.iam_role_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# IAM Role for Cognito Unauthenticated
resource "aws_iam_role" "iam_role_cognito_unauth" {
  name = "${var.prefix}-${var.env}-cognito-unauth-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.id_pool.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "unauthenticated"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "cognito_unauth_policy_01" {
  name = "${var.prefix}-${var.env}-cognito-unauth-policy-01"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "execute-api:Invoke",
      "Resource": [
        "${aws_api_gateway_rest_api.apigw.execution_arn}/*/GET/items"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "cognito_unauth_policy_02" {
  name   = "${var.prefix}-${var.env}-cognito-unauth-policy-02"
  policy = file("./iam-policy/cognito_unauth_policy.json")
}

resource "aws_iam_role_policy_attachment" "cognito_unauth_policy_01_attach" {
  policy_arn = aws_iam_policy.cognito_unauth_policy_01.arn
  role       = aws_iam_role.iam_role_cognito_unauth.name
}

resource "aws_iam_role_policy_attachment" "cognito_unauth_policy_02_attach" {
  policy_arn = aws_iam_policy.cognito_unauth_policy_02.arn
  role       = aws_iam_role.iam_role_cognito_unauth.name
}

# IAM Role for Cognito Authenticated
resource "aws_iam_role" "iam_role_cognito_auth" {
  name = "${var.prefix}-${var.env}-cognito-auth-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.id_pool.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "authenticated"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "cognito_auth_policy_01" {
  name = "${var.prefix}-${var.env}-cognito-auth-policy-01"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "execute-api:Invoke",
      "Resource": [
        "${aws_api_gateway_rest_api.apigw.execution_arn}/*/GET/items",
        "${aws_api_gateway_rest_api.apigw.execution_arn}/*/POST/items"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "cognito_auth_policy_02" {
  name   = "${var.prefix}-${var.env}-cognito-auth-policy-02"
  policy = file("./iam-policy/cognito_auth_policy.json")
}

resource "aws_iam_role_policy_attachment" "cognito_auth_policy_01_attach" {
  policy_arn = aws_iam_policy.cognito_auth_policy_01.arn
  role       = aws_iam_role.iam_role_cognito_auth.name
}

resource "aws_iam_role_policy_attachment" "cognito_auth_policy_02_attach" {
  policy_arn = aws_iam_policy.cognito_auth_policy_02.arn
  role       = aws_iam_role.iam_role_cognito_auth.name
}
