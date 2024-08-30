using OrchardCore.Logging;
using Serilog;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

builder.Host.UseSerilog((hostingContext, configBuilder) =>
    {
        _ = configBuilder.ReadFrom.Configuration(hostingContext.Configuration)
        .Enrich.FromLogContext();
    });

builder.Services.AddOrchardCms();

WebApplication app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    _ = app.UseExceptionHandler("/Error");
    _ = app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseOrchardCore(c => c.UseSerilogTenantNameLogging());

app.Run();
