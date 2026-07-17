using PizzaSatinAlmaYonetimi.Web.Models;namespace PizzaSatinAlmaYonetimi.Web.Services;
public interface ISatinAlmaOnayService{Task<IReadOnlyList<OnayBekleyenTeklif>>ListeleAsync(CancellationToken ct);Task SiparisOlusturAsync(int teklifId,int kullaniciId,CancellationToken ct);}
