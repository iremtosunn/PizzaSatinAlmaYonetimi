using PizzaSatinAlmaYonetimi.Web.Models;

namespace PizzaSatinAlmaYonetimi.Web.Services;

public interface IGirisService
{
    Task<OturumKullanicisi?> DogrulaAsync(string kullaniciAdi, string sifre, CancellationToken cancellationToken);
}
