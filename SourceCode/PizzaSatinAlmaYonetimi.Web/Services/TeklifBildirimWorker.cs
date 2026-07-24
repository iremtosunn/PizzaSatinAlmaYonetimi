namespace PizzaSatinAlmaYonetimi.Web.Services;
public sealed class TeklifBildirimWorker(IServiceScopeFactory scopes,ILogger<TeklifBildirimWorker> logger):BackgroundService
{
 protected override async Task ExecuteAsync(CancellationToken stoppingToken){while(!stoppingToken.IsCancellationRequested){try{using var scope=scopes.CreateScope();await scope.ServiceProvider.GetRequiredService<IBildirimService>().TeklifGecerlilikUyarilariniOlusturAsync(stoppingToken);await scope.ServiceProvider.GetRequiredService<IOperasyonBildirimService>().BildirimleriOlusturAsync(stoppingToken);}catch(OperationCanceledException)when(stoppingToken.IsCancellationRequested){break;}catch(Exception ex){logger.LogError(ex,"Otomatik bildirimler oluşturulamadı.");}await Task.Delay(TimeSpan.FromHours(1),stoppingToken);}}
}
