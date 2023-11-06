# Dotnet AWS Lambda Cognito

This project is developed to test dotnet Lambda implementation to create, authenticate and get user in AWS Cognito

## Resources used

- DotNet 6
- Lambda
- Cognito
- Terraform
- API Gateway

## What is AWS Lambda?

Is a serverless computing service provided by Amazon Web Services (AWS). It allows developers to run code in response to events without the need to manage servers. Users upload their code to Lambda, define the triggering events (e.g., HTTP requests, database updates), and AWS automatically scales and manages the infrastructure. Lambda supports various programming languages and can execute code in milliseconds, making it ideal for microservices, data processing, and automation tasks. Users are billed based on the compute time their code consumes, providing cost-effective and scalable solutions for a wide range of applications.

<p align="start" style="margin-left: 20px">
  <img src="./assets/lambda.png" width="100" />
</p>

## What is AWS Cognito?

Is a fully managed identity and user management service from Amazon Web Services. It allows developers to easily add authentication, authorization, and user management to their applications. Cognito supports multiple identity providers, including social media logins, and provides features like multi-factor authentication, user sign-up and sign-in, and secure access control. It's designed to work seamlessly with mobile and web apps and can synchronize user data across devices. Cognito enables developers to focus on building their applications while AWS takes care of the complexities of managing user identities and access. It's a crucial component for building secure and scalable user-centric applications.

<p align="start" style="margin-left: 20px">
  <img src="./assets/cognito.png" width="100" />
</p>

## Test

To test Lambda on localhost, you need to install some resources:

```console
dotnet tool install -g Amazon.Lambda.TestTool-6.0
```

Into folder `.vscode` add `launch.json` file with:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": ".NET Core Launch (console)",
      "type": "coreclr",
      "request": "launch",
      "preLaunchTask": "build",
      "program": "${env:USERPROFILE}/.dotnet/tools/dotnet-lambda-test-tool-6.0.exe",
      "args": [],
      "cwd": "${workspaceFolder}/Lambdas/AuthLambda",
      "console": "internalConsole",
      "stopAtEntry": false,
      "internalConsoleOptions": "openOnSessionStart"
    }
  ]
}
```

Into property `cwd` configure your Lambda path to test, and press `F5` to start execution

When open the screen on browser, insert this value on textarea:

```json
{
  "version": "2.0",
  "routeKey": "$default",
  "rawPath": "/path/to/resource",
  "requestContext": {
    "accountId": "123456789012",
    "apiId": "api-id",
    "domainName": "id.execute-api.us-east-1.amazonaws.com",
    "domainPrefix": "domain-id",
    "http": {
      "method": "POST",
      "path": "/path/to/resource",
      "protocol": "HTTP/1.1",
      "sourceIp": "IP",
      "userAgent": "agent"
    },
    "requestId": "request-id",
    "routeId": "route-id",
    "routeKey": "$default-route",
    "stage": "$default-stage",
    "time": "12/Mar/2020:19:03:58 +0000",
    "timeEpoch": 1583348638390
  },
  "body": "{\"Email\":\"guilherme.nascimento@email.com\", \"Password\":\"12345678\", \"Name\": \"Guilherme\"}",
  "isBase64Encoded": false
}
```

## How to implement

Install the resources:

```console
dotnet new --install Amazon.Lambda.Templates
```

```console
dotnet tool install -g Amazon.Lambda.Tools
```

Create Project:

```console
dotnet new lambda.EmptyFunction -n <project_name>
```

To enable communication with AWS API Gateway, install the package into your project:

- [Amazon.Lambda.APIGatewayEvents](https://www.nuget.org/packages/Amazon.Lambda.APIGatewayEvents)

To communication with Cognito:

- [AWSSDK.CognitoIdentity](https://www.nuget.org/packages/AWSSDK.CognitoIdentity)
- [AWSSDK.CognitoIdentityProvider](https://www.nuget.org/packages/AWSSDK.CognitoIdentityProvider)

### Create User

```c#
using (var provider = new AmazonCognitoIdentityProviderClient(RegionEndpoint.USEast2))
{
    var userPoolService = new UserPoolService(provider);

    var userPoolId = await userPoolService.GetUserPoolId();
    var clientId = await userPoolService.GetUserPoolClientId(userPoolId);
    var userAttributes = new List<AttributeType>
    {
        new AttributeType
        {
            Name = "name",
            Value = userDto.Name
        }
    };

    var signUpResponse = await provider.SignUpAsync(new SignUpRequest
    {
        ClientId = clientId,
        Username = userDto.Email,
        Password = userDto.Password,
        UserAttributes = userAttributes,
    });

    await provider.AdminConfirmSignUpAsync(new AdminConfirmSignUpRequest
    {
        UserPoolId = userPoolId,
        Username = userDto.Email,
    });

    return HttpStatusResult.Created();
}
```

### Auth

```c#
using (var provider = new AmazonCognitoIdentityProviderClient(RegionEndpoint.USEast2))
{
    var userPoolService = new UserPoolService(provider);

    var userPoolId = await userPoolService.GetUserPoolId();
    var clientId = await userPoolService.GetUserPoolClientId(userPoolId);

    var userPool = new CognitoUserPool(userPoolId, clientId, provider);
    var user = new CognitoUser(auth.Email, clientId, userPool, provider);
    var authRequest = new InitiateAdminNoSrpAuthRequest { Password = auth.Password };
    var authResponse = await user.StartWithAdminNoSrpAuthAsync(authRequest);

    if (authResponse.AuthenticationResult != null)
    {
        return HttpStatusResult.Ok(JsonSerializer.Serialize(new
        {
            Token = authResponse.AuthenticationResult.AccessToken,
            ExpiresIn = authResponse.AuthenticationResult.ExpiresIn
        }));
    }

    return HttpStatusResult.Unauthorized();
}
```

### Utils

To get `UserPoolId` and `ClientId`, implement the service:

```c#
public class UserPoolService
{
    private readonly AmazonCognitoIdentityProviderClient _provider;

    public UserPoolService(AmazonCognitoIdentityProviderClient provider)
    {
        _provider = provider;
    }

    public async Task<string> GetUserPoolId()
    {
        var userPoolId = (await _provider.ListUserPoolsAsync(new ListUserPoolsRequest()))
            .UserPools.FirstOrDefault(x => x.Name == "<your-pool-name>")?.Id ?? throw new InvalidOperationException("Not found!");

        return userPoolId;
    }

    public async Task<string> GetUserPoolClientId(string userPoolId)
    {
        var clientId = (await _provider.ListUserPoolClientsAsync(new ListUserPoolClientsRequest { UserPoolId = userPoolId }))
            .UserPoolClients.FirstOrDefault()?.ClientId ?? throw new InvalidOperationException("Not found!");

        return clientId;
    }
}
```
