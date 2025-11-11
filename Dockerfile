# --------- build args ---------
ARG BASE_IMAGE_REPO=mcr.microsoft.com
ARG BASE_IMAGE_BUILD=dotnet/sdk
ARG BASE_IMAGE_BUILD_TAG=9.0
ARG BASE_IMAGE_RUNTIME=dotnet/aspnet
ARG BASE_IMAGE_RUNTIME_TAG=9.0

# --------- build stage ---------
FROM ${BASE_IMAGE_REPO}/${BASE_IMAGE_BUILD}:${BASE_IMAGE_BUILD_TAG} AS build

ARG VERSION_PREFIX=0.1.3
ARG VERSION_SUFFIX=""
ARG ENVIRONMENT=docker
ENV DOTNET_ENVIRONMENT=${ENVIRONMENT}

WORKDIR /sln

# Кладём весь исходник (ускоряй через .dockerignore)
COPY . .

# Рестор по .sln в корне контекста
RUN set -eux; \
    SOLN="$(find . -maxdepth 1 -name '*.sln' -print -quit)"; \
    if [ -z "$SOLN" ]; then echo 'No .sln found'; exit 1; fi; \
    dotnet restore "$SOLN" -v minimal

# Сборка sol'n
RUN set -eux; \
    SOLN="$(find . -maxdepth 1 -name '*.sln' -print -quit)"; \
    if [ -n "${VERSION_SUFFIX:-}" ]; then VS_ARG="-p:VersionSuffix=${VERSION_SUFFIX}"; else VS_ARG=""; fi; \
    dotnet build "$SOLN" --no-restore -c Release -v minimal -p:VersionPrefix=${VERSION_PREFIX} $VS_ARG

# --------- publish stage ---------
FROM build AS publish
ARG VERSION_PREFIX=0.1.3
ARG VERSION_SUFFIX=""
ARG API_PROJECT_PATH=""   # можно переопределить: --build-arg API_PROJECT_PATH=backend/ApiService/Source/Api/Api.csproj

WORKDIR /sln
RUN set -eux; \
    if [ -n "${API_PROJECT_PATH}" ]; then \
        API_PROJ="${API_PROJECT_PATH}"; \
        [ -f "$API_PROJ" ] || { echo "API_PROJECT_PATH not found: $API_PROJ"; exit 1; }; \
    else \
        API_PROJ="$(find . -type f -name '*Api.csproj' -print -quit)"; \
        [ -n "$API_PROJ" ] || { echo 'No *Api.csproj found'; exit 1; }; \
    fi; \
    if [ -n "${VERSION_SUFFIX:-}" ]; then VS_ARG="-p:VersionSuffix=${VERSION_SUFFIX}"; else VS_ARG=""; fi; \
    dotnet publish "$API_PROJ" --no-restore -c Release -v minimal -o /app -p:VersionPrefix=${VERSION_PREFIX} $VS_ARG

# --------- runtime ---------
FROM ${BASE_IMAGE_REPO}/${BASE_IMAGE_RUNTIME}:${BASE_IMAGE_RUNTIME_TAG} AS run
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
# окружение можно переопределить через compose
ENV ASPNETCORE_ENVIRONMENT=Development

COPY --from=publish /app ./

# Если имя DLL иное — поправь строку ниже
ENTRYPOINT ["dotnet", "Epam.ItMarathon.ApiService.Api.dll"]
