namespace PizzaSatinAlmaYonetimi.Web.Services;

public interface ISifreDogrulamaService
{
    bool Dogrula(string sifre, byte[] salt, byte[] beklenenHash);
}
