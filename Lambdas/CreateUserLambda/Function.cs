using System.Text.Json;
using Amazon;
using Amazon.CognitoIdentityProvider;
using Amazon.CognitoIdentityProvider.Model;
using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using Auth.Common.Dtos;
using Aws.Common.Services;
using Http.Common;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace CreateUserLambda;

public class Function
{
    public async Task<APIGatewayProxyResponse> FunctionHandler(APIGatewayProxyRequest apigProxyEvent, ILambdaContext context)
    {
        if (string.IsNullOrEmpty(apigProxyEvent.Body))
            return HttpStatusResult.BadRequest("Invalid request!");

        try
        {
            var userDto = JsonSerializer.Deserialize<CreateUserDto>(apigProxyEvent.Body, new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });

            if (userDto == null)
                return HttpStatusResult.BadRequest("Invalid body!");

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
        }
        catch (Exception ex)
        {
            return HttpStatusResult.BadRequest(ex.Message);
        }
    }
}
