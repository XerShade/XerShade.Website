# Build stage: compiles and publishes the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy only the csproj and restore dependencies as a distinct layer
COPY ["source/XerShade.Website/XerShade.Website.csproj", "source/XerShade.Website/"]
RUN dotnet restore "source/XerShade.Website/XerShade.Website.csproj"

# Copy the remaining files and build the application
COPY . .
WORKDIR "/src/source/XerShade.Website"
RUN dotnet publish "XerShade.Website.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Final stage: copies publish output from publish stage
FROM mcr.microsoft.com/dotnet/runtime:8.0 AS final
USER app
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "XerShade.Website.dll"]
