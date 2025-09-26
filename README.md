# Dotnet AWS Lambda Cognito

This project is developed to test dotnet Lambda implementation to create, authenticate and get user in AWS Cognito


## ✨ Features

- **Serverless REST API with AWS Lambda**: .NET 6 Lambda functions for authentication, user creation, and user info retrieval, optimized for on-demand execution and low cost.
- **User Management with AWS Cognito**: Full integration for user registration, authentication, and secure management using Amazon Cognito User Pools.
- **API Gateway with JWT Authorization**: Exposes Lambdas via HTTP API Gateway, with routes protected by JWT and direct Cognito integration.
- **Infrastructure as Code with Terraform**: Provision all AWS resources (Lambda, Cognito, API Gateway, IAM, S3) in a modular and reproducible way.
- **S3 Storage for Lambda Deployment**: Uses S3 bucket for versioning and deployment of Lambda function packages.
- **Automated CI/CD with GitHub Actions**: Pipeline for build, restore, publish, and infrastructure provisioning via Terraform on every push to the main branch.
- **Componentization and Code Reuse**: Project structured in multiple shared libraries for DTOs, AWS services, and standardized HTTP responses.

<br>

## 📚 Resources

- [.NET 9](https://dotnet.microsoft.com/pt-br/)
- [AWS](https://aws.amazon.com)
- [Terraform](https://developer.hashicorp.com/terraform)
- [GitHub Actions](https://github.com/features/actions)

<br>

<img 
    align="left" 
    alt="C#" 
    title="C#"
    width="40px" 
    style="padding-right: 10px;" 
    src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/csharp/csharp-plain.svg"
/>
<img 
    align="left" 
    alt="AWS" 
    title="AWS"
    width="40px" 
    style="padding-right: 10px;" 
    src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/amazonwebservices/amazonwebservices-original-wordmark.svg"
/>
<img 
    align="left" 
    alt="Terraform" 
    title="Terraform"
    width="40px" 
    style="padding-right: 10px;" 
    src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/terraform/terraform-original.svg"
/>
<img 
    align="left" 
    alt="GitHub Actions" 
    title="GitHub Actions"
    width="40px" 
    style="padding-right: 10px;" 
    src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/githubactions/githubactions-original.svg"
/>

<br>
<br>

## 🚀 Installation

### AWS Configure

Go to [this repository](https://github.com/ganascimento/dotnet-aws-s3) and configure your aws cli to run your lambda

### .NET Configure

Install AWS Lambda Tools on .NET:

```console
dotnet tool install -g Amazon.Lambda.Tools
```

Check the installed version:
```console
dotnet tool list -g
```

Install AWS Lambda templates:
```console
dotnet new install Amazon.Lambda.Templates
```

Check installed templates:
```console
dotnet new list lambda
```

Create new Lambda:
```console
dotnet new lambda.EmptyFunction -n <name> -o ./
```
<br>

## 🧪 Test/Run Project

To test Lambda on localhost, you need to install some resources:

```console
dotnet tool install -g Amazon.Lambda.TestTool-8.0
```

Create `.vscode` folder and add file `launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": ".NET Core Launch (console)",
      "type": "coreclr",
      "request": "launch",
      "preLaunchTask": "build",
      "program": "${env:HOME}/.dotnet/tools/dotnet-lambda-test-tool-8.0",
      "args": [],
      "cwd": "${workspaceFolder}/Lambdas/CreateUserLambda",
      "console": "internalConsole",
      "stopAtEntry": false,
      "internalConsoleOptions": "openOnSessionStart"
    }
  ]
}
```

Check the `program`, in this example this execution is on `Linux`

And change `cwd` to your Lambda