using AssettoServer.Shared.Network.Http;
using AssettoServer.Server.Plugin;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using System.Threading.Tasks;
using Microsoft.Extensions.DependencyInjection;

public class ConnectRulesPlugin : IAssettoServerPlugin
{
    private const string ImageUrl = "http://xxx.jpg";
    private const string RuleText = "xxx\nxxx";
    private const string DiscordInviteUrl = "https://xxx";
    private const string ServerWebsiteUrl = "http://xxx";
    private const string ButtonText = "I understand and accept the rules";

    public void ConfigureServices(IServiceCollection services)
    {
    }

    public void ConfigureApplication(IApplicationBuilder app)
    {
        app.UseMiddleware<ConnectRulesMiddleware>();
    }
}

public class ConnectRulesMiddleware : IMiddleware
{
    public async Task InvokeAsync(HttpContext context, RequestDelegate next)
    {
        if (context.Request.Path == "/api/connected_clients")
        {
            var connectedClients = await context.RequestServices.GetService<IConnectedClients>().GetClientsAsync();

            await context.Response.WriteAsync(GetModalHtml());
        }
        else
        {
            await next(context);
        }
    }

    private string GetModalHtml()
    {
        string cssStyle = @"
            body {
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                background-color: rgba(0, 0, 0, 0.5);
                backdrop-filter: blur(10px);
            }
            .modal {
                background-color: black;
                color: white;
                padding: 20px;
                border-radius: 5px;
                max-width: 80%;
                text-align: center;
            }
            .modal img {
                max-width: 200px;
                margin-bottom: 20px;
            }
            .modal pre {
                text-align: left;
                white-space: pre-wrap;
                margin-bottom: 20px;
            }
            .modal p {
                margin-bottom: 10px;
            }
            .modal a {
                color: white;
                text-decoration: underline;
            }
            .modal button {
                background-color: white;
                color: black;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }
        ";
        return $@"
            <html>
                <head>
                    <style>{cssStyle}</style>
                </head>
                <body>
                    <div class='modal'>
                        <img src='{ImageUrl}' />
                        <pre>{RuleText}</pre>
                        <p>You can also join our <a href='{DiscordInviteUrl}' target='_blank'>Discord server</a> to stay up to date with the latest news and events.</p>
                        <p>You can also find the list of our servers on our <a href='{ServerWebsiteUrl}' target='_blank'>website</a>.</p>
                        <button>{ButtonText}</button>
                    </div>
                </body>
            </html>
        ";
    }
}