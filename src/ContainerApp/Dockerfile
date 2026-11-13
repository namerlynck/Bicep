FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY ContainerApp.csproj .
RUN dotnet restore
COPY . .
RUN dotnet publish --configuration Release --output /app --no-restore

FROM mcr.microsoft.com/dotnet/runtime:10.0
WORKDIR /app
COPY --from=build /app .
USER $APP_UID
ENTRYPOINT ["dotnet", "ContainerApp.dll"]
