# Create an intermediate image using .NET Core SDK
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
LABEL stage=build-env
WORKDIR /app

# Copy and build in the intermediate image
COPY ./source /app
RUN dotnet publish /app/XerShade.Website -c Release -o ./build/release

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 80
USER root
ENV ASPNETCORE_URLS http://+:80
COPY --from=build-env /app/build/release .
ENTRYPOINT ["dotnet", "XerShade.Website.dll"]
