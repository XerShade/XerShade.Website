#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS publish
LABEL stage=publish
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

COPY ["source/XerShade.Website/XerShade.Website.csproj", "source/XerShade.Website/"]
RUN dotnet restore "./source/XerShade.Website/./XerShade.Website.csproj"

COPY . .
WORKDIR "/src/source/XerShade.Website"
RUN dotnet publish "./XerShade.Website.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
USER root
WORKDIR /app
EXPOSE 80
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "XerShade.Website.dll"]
