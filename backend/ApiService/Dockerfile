# -------- build --------
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

ARG VERSION_PREFIX=0.1.3
ARG VERSION_SUFFIX=""
ARG ENVIRONMENT=Production
ARG API_PROJECT_PATH="backend/ApiService/Source/Api/Api.csproj"

ENV DOTNET_ENVIRONMENT=${ENVIRONMENT}
WORKDIR /src

COPY . .

RUN set -eux; \
    if [ ! -f "${API_PROJECT_PATH}" ]; then \
        echo "Api csproj not found: ${API_PROJECT_PATH}"; \
        ls -R; \
        exit 1; \
    fi; \
    echo "Using API project: ${API_PROJECT_PATH}"; \
    dotnet restore "${API_PROJECT_PATH}" -v minimal; \
    VS_ARG=""; if [ -n "${VERSION_SUFFIX}" ]; then VS_ARG="-p:VersionSuffix=${VERSION_SUFFIX}"; fi; \
    dotnet build   "${API_PROJECT_PATH}" --no-restore -c Release -v minimal -p:VersionPrefix=${VERSION_PREFIX} $VS_ARG; \
    dotnet publish "${API_PROJECT_PATH}" --no-restore -c Release -v minimal -o /app -p:VersionPrefix=${VERSION_PREFIX} $VS_ARG

# -------- runtime --------
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS run

WORKDIR /app

# .NET 9 / Kestrel: слушаем 8080 на всех интерфейсах
ENV ASPNETCORE_ENVIRONMENT=Production
ENV DOTNET_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
# (дополнительно можно, но не обязательно)
ENV ASPNETCORE_HTTP_PORTS=8080

EXPOSE 8080

COPY --from=build /app ./

# Healthcheck для оркестраторов / докера
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl -f http://localhost:8080/api/system/info || exit 1

ENTRYPOINT ["dotnet", "Epam.ItMarathon.ApiService.Api.dll"]
