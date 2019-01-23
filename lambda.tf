resource "aws_iam_role" "iam_for_redirect_lambda" {
  name = "laa_iam_for_redirect_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = "${aws_iam_role.iam_for_redirect_lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudwatchLogsFullAccess"
}

data "archive_file" "redirect_lambda_zip" {
  type = "zip"

  output_path = "redirect_lambda.zip"
  source_file = "${path.module}/lambda_code/redirect.js"
}

resource "aws_lambda_function" "redirect_lambda" {
  filename         = "redirect_lambda.zip"
  function_name    = "laa_redirect_lambda"
  role             = "${aws_iam_role.iam_for_redirect_lambda.arn}"
  handler          = "redirect.handler"
  source_code_hash = "${data.archive_file.redirect_lambda_zip.output_base64sha256}"
  runtime          = "nodejs8.10"
  publish          = true
}
