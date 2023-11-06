using System.Text.Json;
using Amazon;
using Amazon.CognitoIdentityProvider;
using Amazon.CognitoIdentityProvider.Model;
using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using Http.Common;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace GetUserInfoLambda;

public class Function
{
    public async Task<APIGatewayProxyResponse> FunctionHandler(APIGatewayProxyRequest apigProxyEvent, ILambdaContext context)
    {
        try
        {
            var userName = Convert.ToString(apigProxyEvent.RequestContext.Authorizer.Claims["username"]);
            var iss = Convert.ToString(apigProxyEvent.RequestContext.Authorizer.Claims["iss"]);
            var stringReplaced = iss.Split("/");
            var userPoolId = stringReplaced.LastOrDefault();

            using (var provider = new AmazonCognitoIdentityProviderClient(RegionEndpoint.USEast2))
            {
                var result = await provider.AdminGetUserAsync(new AdminGetUserRequest
                {
                    Username = userName,
                    UserPoolId = userPoolId
                });

                return HttpStatusResult.Ok(JsonSerializer.Serialize(new
                {
                    Attributes = result.UserAttributes
                }));
            }
        }
        catch (Exception ex)
        {
            return HttpStatusResult.BadRequest(ex.Message);
        }
    }
}
