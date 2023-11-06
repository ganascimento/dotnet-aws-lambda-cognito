resource "aws_lambda_function" "auth_lambda" {
  function_name = "AuthLambda"

  s3_bucket = var.s3_bucket_id
  s3_key    = aws_s3_object.auth_lambda.key

  runtime = "dotnet6"
  handler = "AuthLambda::AuthLambda.Function::FunctionHandler"

  source_code_hash = data.archive_file.auth_lambda.output_base64sha256

  role = var.lambda_role_arn

  timeout = 10
}

data "archive_file" "auth_lambda" {
  type = "zip"

  source_dir  = "../Lambdas/AuthLambda/bin/Release/net6.0/linux-x64/publish"
  output_path = "./auth_lambda.zip"
}

resource "aws_s3_object" "auth_lambda" {
  bucket = var.s3_bucket_id

  key    = "auth_lambda.zip"
  source = data.archive_file.auth_lambda.output_path

  etag = filemd5(data.archive_file.auth_lambda.output_path)
}
