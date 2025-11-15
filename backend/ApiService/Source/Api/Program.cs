using Epam.ItMarathon.ApiService.Api.Extension;
using Epam.ItMarathon.ApiService.Application;
using Serilog;

try
{
    var builder = WebApplication
        .CreateBuilder(args)
        .ConfigureApplicationBuilder();

    // Application слой (MediatR + FluentValidation)
    builder.Services.InjectApplicationLayer();

    var app = builder.Build();

    // 1. Статика для фронта из wwwroot
    app.UseDefaultFiles();   // ищет index.html в wwwroot
    app.UseStaticFiles();    // раздаёт файлы из wwwroot и wwwroot/assets

    // 2. Вся "оригинальная" конфигурация приложения (логирование, CORS, Swagger, минимальные API, миграции)
    app.ConfigureApplication();

    // 3. SPA-fallback: любые пути БЕЗ точки (не файлы) → index.html
    //   /room/..., /join/... → фронт
    //   /swagger, /swagger/index.html → свои пути
    //   /assets/... .js/.css/.svg → НЕ попадают сюда
    app.MapFallbackToFile("{*path:nonfile}", "index.html");

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
