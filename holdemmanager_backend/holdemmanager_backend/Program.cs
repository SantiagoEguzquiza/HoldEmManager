using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using holdemmanager_backend_app.Domain.IRepositories;
using holdemmanager_backend_app.Domain.IServices;
using holdemmanager_backend_app.Persistence.Repositories;
using holdemmanager_backend_app.Service;
using holdemmanager_backend_app.Persistence;
using holdemmanager_backend_web.Domain.IRepositories;
using holdemmanager_backend_web.Persistence.Repositories;
using holdemmanager_backend_web.Domain.IServices;
using holdemmanager_backend_web.Service;
using holdemmanager_backend_web.Persistence;
using holdemmanager_backend_web.Repositories;
using holdemmanager_backend_app.Utils;
using holdemmanager_backend_app.Repositories;


var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
var connectionStringApp = builder.Configuration.GetConnectionString("ConexionApp");
var connectionStringWeb = builder.Configuration.GetConnectionString("ConexionWeb");

builder.Services.AddScoped<IJugadorRepositoryApp, JugadorRepositoryApp>();
builder.Services.AddScoped<IJugadorServiceApp, JugadorServiceApp>();
builder.Services.AddScoped<ILoginRepositoryApp, LoginRepositoryApp>();
builder.Services.AddScoped<ILoginServiceApp, LoginServiceApp>();
builder.Services.AddScoped<IMapaRepositoryApp, MapaRepositoryApp>();
builder.Services.AddScoped<IMapaServiceApp, MapaServiceApp>();
builder.Services.AddScoped<IFeedbackRepositoryApp, FeedbackRepositoryApp>();
builder.Services.AddScoped<IFeedbackServiceApp, FeedbackServiceApp>();

builder.Services.AddScoped<IUsuarioRepositoryWeb, UsuarioRepositoryWeb>();
builder.Services.AddScoped<IUsuarioServiceWeb, UsuarioServiceWeb>();
builder.Services.AddScoped<ILoginRepositoryWeb, LoginRepositoryWeb>();
builder.Services.AddScoped<ILoginServiceWeb, LoginServiceWeb>();
builder.Services.AddScoped<IRecursosEducativosRepositoryWeb, RecursosEducativosRepositoryWeb>();
builder.Services.AddScoped<IRecursosEducativosServiceWeb, RecursosEducativosServiceWeb>();
builder.Services.AddScoped<IContactoRepositoryWeb, ContactoRepositoryWeb>();
builder.Services.AddScoped<IContactoServiceWeb, ContactoServiceWeb>();
builder.Services.AddScoped<INoticiasRepositoryWeb, NoticiasRepositoryWeb>();
builder.Services.AddScoped<INoticiasServiceWeb, NoticiasServiceWeb>();
builder.Services.AddScoped<ITorneosRepositoryWeb, TorneoRepositoryWeb>();
builder.Services.AddScoped<ITorneosServiceWeb, TorneoServiceWeb>();
builder.Services.AddScoped<IRankingRepositoryWeb, RankingRepositoryWeb>();
builder.Services.AddScoped<IRankingServiceWeb, RankingServiceWeb>();

builder.Services.AddSingleton<FirebaseStorageHelper>();

builder.Services.AddDbContext<AplicationDbContextApp>(options =>
{
    options.UseSqlServer(connectionStringApp);
});
builder.Services.AddDbContext<AplicationDbContextWeb>(options =>
{
    options.UseSqlServer(connectionStringWeb);
});

// Cors
builder.Services.AddCors(options => options.AddPolicy("AllowWebapp",
                                            builder => builder.AllowAnyOrigin()
                                            .AllowAnyHeader()
                                            .AllowAnyMethod()));

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                 .AddJwtBearer(options => options.TokenValidationParameters = new TokenValidationParameters
                 {

                     ValidateIssuer = true,
                     ValidateAudience = true,
                     ValidateLifetime = true,
                     ValidateIssuerSigningKey = true,
                     ValidIssuer = builder.Configuration["Jwt:Issuer"],
                     ValidAudience = builder.Configuration["Jwt:Audience"],
                     IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["Jwt:SecretKey"])),
                     ClockSkew = TimeSpan.Zero


                 });


var app = builder.Build();

app.UseCors("AllowWebapp");

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}


app.UseAuthorization();
app.UseAuthentication();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<AplicationDbContextWeb>();
    DefaultUsers.create(context);
}

app.Run();
