resource "aws_lambda_function" "get_user_lambda" {
  function_name = "GetUserInfoLambda"

  s3_bucket = var.s3_bucket_id
  s3_key    = aws_s3_object.get_user_lambda.key

  runtime = "dotnet6"
  handler = "GetUserInfoLambda::GetUserInfoLambda.Function::FunctionHandler"

  source_code_hash = data.archive_file.get_user_lambda.output_base64sha256

  role = var.lambda_role_arn

  timeout = 10
}

data "archive_file" "get_user_lambda" {
  type = "zip"

  source_dir  = "../Lambdas/GetUserInfoLambda/bin/Release/net6.0/linux-x64/publish"
  output_path = "./get_user_lambda.zip"
}

resource "aws_s3_object" "get_user_lambda" {
  bucket = var.s3_bucket_id

  key    = "get_user_lambda.zip"
  source = data.archive_file.get_user_lambda.output_path

  etag = filemd5(data.archive_file.get_user_lambda.output_path)
}
