using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using Epam.ItMarathon.ApiService.Api.Endpoints;
using Epam.ItMarathon.ApiService.Infrastructure.Database;
using Serilog;

namespace Epam.ItMarathon.ApiService.Api.Extension
{
    [ExcludeFromCodeCoverage]
    public static class WebApplicationExtensions
    {
        public static WebApplication ConfigureApplication(this WebApplication application)
        {
            #region Logging
            application.UseSerilogRequestLogging();
            #endregion

            #region Security
            application.UseHsts();
            application.UseHttpsRedirection();
            application.UseCors();
            #endregion

            #region Swagger
            var textInfo = CultureInfo.CurrentCulture.TextInfo;

            application.UseSwagger();
            application.UseSwaggerUI(c =>
                c.SwaggerEndpoint(
                    "/swagger/v1/swagger.json",
                    $"Secret Nick API - {textInfo.ToTitleCase(application.Environment.EnvironmentName)} - V1"));
            #endregion

            #region MinimalApi
            application.MapSystemEndpoints();
            application.MapRoomEndpoints();
            application.MapUserEndpoints();
            #endregion

            #region Database
            application.Services.MigrateDatabase();
            #endregion

            return application;
        }
    }
}
