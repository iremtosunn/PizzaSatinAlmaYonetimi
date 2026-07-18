using PizzaSatinAlmaYonetimi.Web.Data;
using Microsoft.AspNetCore.Authentication.Cookies;
using PizzaSatinAlmaYonetimi.Web.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Logging.ClearProviders();
builder.Logging.AddConsole();
builder.Logging.AddDebug();
builder.Services.AddControllersWithViews();
builder.Services.AddScoped<ISqlConnectionFactory, SqlConnectionFactory>();
builder.Services.AddScoped<IGirisService, GirisService>();
builder.Services.AddScoped<IKullaniciYonetimiService, KullaniciYonetimiService>();
builder.Services.AddScoped<IRolYonetimiService, RolYonetimiService>();
builder.Services.AddScoped<ITedarikciYonetimiService, TedarikciYonetimiService>();
builder.Services.AddScoped<ISatinAlmaTalebiService, SatinAlmaTalebiService>();
builder.Services.AddScoped<ITeklifGirisiService, TeklifGirisiService>();
builder.Services.AddScoped<ITeklifKarsilastirmaService, TeklifKarsilastirmaService>();
builder.Services.AddScoped<ISatinAlmaOnayService, SatinAlmaOnayService>();
builder.Services.AddScoped<IBildirimService, BildirimService>();
builder.Services.AddScoped<IAyarlarService, AyarlarService>();
builder.Services.AddScoped<IDashboardService, DashboardService>();
builder.Services.AddScoped<IRaporlarService, RaporlarService>();
builder.Services.AddSingleton<ISifreDogrulamaService, SifreDogrulamaService>();
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.LoginPath = "/Giris";
        options.AccessDeniedPath = "/Hata/403";
        options.Cookie.Name = "PizzaSatinAlma.Oturum";
        options.Cookie.HttpOnly = true;
        options.Cookie.SameSite = SameSiteMode.Lax;
        options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
        options.ExpireTimeSpan = TimeSpan.FromHours(8);
        options.SlidingExpiration = true;
        options.Events.OnRedirectToLogin = context =>
        {
            context.Response.Redirect(context.HttpContext.User.Identity?.IsAuthenticated == true
                ? options.AccessDeniedPath.Value!
                : options.LoginPath.Value!);
            return Task.CompletedTask;
        };
        options.Events.OnRedirectToAccessDenied = context =>
        {
            context.Response.Redirect(options.AccessDeniedPath.Value!);
            return Task.CompletedTask;
        };
    });

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Hata");
    app.UseHsts();
}

app.UseStatusCodePagesWithReExecute("/Hata/{0}");
app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Giris}/{action=Index}/{id?}");

app.Run();

