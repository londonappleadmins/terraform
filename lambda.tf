resource "aws_iam_role" "iam_for_redirect_lambda" {
  name = "laa_iam_for_redirect_lambda"

  assume_role_policy = "${data.aws_iam_policy_document.iam_for_redirect_lambda.json}"
}

data "aws_iam_policy_document" "iam_for_redirect_lambda" {
  statement {
    sid     = "1"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_logging" {


  statement {
    sid = "1"
    actions = [
      "logs:CreateLogDelivery",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:GetLogEvents",
      "logs:PutDestination",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }

}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = "${data.aws_iam_policy_document.lambda_logging.json}"
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = "${aws_iam_role.iam_for_redirect_lambda.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
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
  runtime          = "nodejs10.x"
  publish          = true
}
