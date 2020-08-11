#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.


FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
RUN apt-get update && apt-get -y install curl gnupg && curl -sL https://deb.nodesource.com/setup_14.x  | bash - && apt-get -y install nodejs


WORKDIR /src
COPY Kaziya.SPA.AppService.Sidecar.csproj Kaziya.SPA.AppService.Sidecar/
RUN dotnet restore "Kaziya.SPA.AppService.Sidecar/Kaziya.SPA.AppService.Sidecar.csproj"
COPY . Kaziya.SPA.AppService.Sidecar/
WORKDIR "/src/Kaziya.SPA.AppService.Sidecar"
RUN dotnet build "Kaziya.SPA.AppService.Sidecar.csproj" -c Release -o /app/build

FROM build AS publish
RUN ls ClientApp/src/app/modules/application/example-reactive-form/
RUN ls ClientApp/src/app/modules/application/example-reactive-form/01-prototype
RUN dotnet publish "Kaziya.SPA.AppService.Sidecar.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS final
EXPOSE 80
EXPOSE 443
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Kaziya.SPA.AppService.Sidecar.dll"]