using PizzaSatinAlmaYonetimi.Web.Models;namespace PizzaSatinAlmaYonetimi.Web.Services;
public interface ITeklifKarsilastirmaService{Task<IReadOnlyList<KarsilastirmaTeklifi>>ListeleAsync(string talepNo,CancellationToken ct);Task SecAsync(string teklifNo,CancellationToken ct);Task ReddetAsync(string teklifNo,CancellationToken ct);}
