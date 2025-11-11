using System.Diagnostics.CodeAnalysis;
using System.Reflection;
using FluentValidation;
using MediatR;
using Microsoft.Extensions.DependencyInjection;

namespace Epam.ItMarathon.ApiService.Application
{
    [ExcludeFromCodeCoverage]
    public static class ApplicationInjection
    {
        public static void InjectApplicationLayer(this IServiceCollection services)
        {
            // Подключаем все MediatR-хендлеры
            services.AddMediatR(cfg =>
                cfg.RegisterServicesFromAssemblies(Assembly.GetExecutingAssembly()));

            // Подключаем все FluentValidation-валидаторы из этой сборки
            services.AddValidatorsFromAssembly(Assembly.GetExecutingAssembly());
        }
    }
}
