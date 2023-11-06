terraform {
  required_providers {
    aws = "~> 5.0"
  }
}

provider "aws" {
  region = "us-east-2"
}

module "s3" {
  source = "./modules/s3"
}

module "cognito" {
  source = "./modules/cognito"
}

module "iam" {
  source = "./modules/iam"
}

module "api-gateway" {
  source                           = "./modules/api-gateway"
  cognito_audience                 = module.cognito.audience
  cognito_issuer                   = module.cognito.issuer
  auth_lambda_function_name        = module.lambda.auth_lambda_function_name
  auth_lambda_invoke_arn           = module.lambda.auth_lambda_invoke_arn
  create_user_lambda_function_name = module.lambda.create_user_lambda_function_name
  create_user_lambda_invoke_arn    = module.lambda.create_user_lambda_invoke_arn
  get_user_lambda_function_name    = module.lambda.get_user_lambda_function_name
  get_user_lambda_invoke_arn       = module.lambda.get_user_lambda_invoke_arn
}

module "lambda" {
  source          = "./modules/lambda"
  s3_bucket_id    = module.s3.lambda_bucket_id
  lambda_role_arn = module.iam.lambda_role_arn
}
