# -------- build --------
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

ARG VERSION_PREFIX=0.1.3
ARG VERSION_SUFFIX=""
ARG ENVIRONMENT=docker
# Можно переопределить при сборке:
# --build-arg API_PROJECT_PATH=backend/ApiService/Source/Api/Api.csproj
ARG API_PROJECT_PATH=""

ENV DOTNET_ENVIRONMENT=${ENVIRONMENT}
WORKDIR /src

# Берём весь репозиторий (ускоряй через .dockerignore)
COPY . .

# Найдём Api.csproj: либо из аргумента, либо первым по маске
RUN set -eux; \
    if [ -n "${API_PROJECT_PATH}" ]; then \
        API_PROJ="${API_PROJECT_PATH}"; \
        if [ ! -f "$API_PROJ" ]; then echo "Api csproj not found: $API_PROJ"; exit 1; fi; \
    else \
        API_PROJ="$(find . -type f -name '*Api.csproj' -print -quit)"; \
        if [ -z "$API_PROJ" ]; then echo 'No *Api.csproj found (pass --build-arg API_PROJECT_PATH=...)'; exit 1; fi; \
    fi; \
    echo "Using API project: $API_PROJ"; \
    dotnet restore "$API_PROJ" -v minimal; \
    VS_ARG=""; if [ -n "${VERSION_SUFFIX}" ]; then VS_ARG="-p:VersionSuffix=${VERSION_SUFFIX}"; fi; \
    dotnet build   "$API_PROJ" --no-restore -c Release -v minimal -p:VersionPrefix=${VERSION_PREFIX} $VS_ARG; \
    dotnet publish "$API_PROJ" --no-restore -c Release -v minimal -o /app -p:VersionPrefix=${VERSION_PREFIX} $VS_ARG

# -------- runtime --------
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS run
WORKDIR /app
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
EXPOSE 8080

COPY --from=build /app ./

# Если имя DLL иное — поправь строку ниже
ENTRYPOINT ["dotnet", "Epam.ItMarathon.ApiService.Api.dll"]
