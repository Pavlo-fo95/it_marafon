using Epam.ItMarathon.ApiService.Api.Extension;
using Epam.ItMarathon.ApiService.Application;
using Serilog;

try
{
    var builder = WebApplication
        .CreateBuilder(args)
        .ConfigureApplicationBuilder();

    // Подключаем Application слой (MediatR + FluentValidation)
    builder.Services.InjectApplicationLayer();

    var app = builder
        .Build()
        .ConfigureApplication();

    // В продакшне включаем редирект на HTTPS
    if (!app.Environment.IsDevelopment())
    {
        // Если UseHttpsRedirection уже вызывается внутри ConfigureApplication(),
        // этот блок можно удалить, чтобы не было дубля.
        app.UseHttpsRedirection();
    }

    Log.Information("Starting host...");
    app.Run();

    return 0;
}
catch (Exception ex)
{
    Log.Fatal(ex, "Host terminated unexpectedly");
    return 1;
}
finally
{
    Log.CloseAndFlush();
}
