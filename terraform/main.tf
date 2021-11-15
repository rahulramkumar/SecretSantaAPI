provider "aws" {
  region = "us-west-2"
}

data aws_region "region" {}
data aws_caller_identity "identity" {}

resource "aws_lambda_function" "secret-santa-api" {
  function_name = "secret-santa-api"

  runtime = "python3.8"
  handler = "main.lambda_handler"

  filename         = data.archive_file.secret-santa-api-build.output_path
  source_code_hash = data.archive_file.secret-santa-api-build.output_base64sha256

  role = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      stage = "prod"
      PARTICIPANTS_TABLE = aws_dynamodb_table.participants-table.name
    }
  }
}

data "archive_file" "secret-santa-api-build" {
  type = "zip"

  source_dir  = "../src"
  output_path = "../build/secret-santa-deployment.zip"
}