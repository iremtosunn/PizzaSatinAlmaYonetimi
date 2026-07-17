namespace PizzaSatinAlmaYonetimi.Web.Models;
public sealed record KarsilastirmaTeklifi(string TeklifNo,string TalepNo,string UrunAdi,string TalepEden,string FirmaAdi,decimal TeklifTutari,string ParaBirimi,int TeslimSuresiGun,DateTime? Skt,DateTime? GecerlilikTarihi,string Durum);
public sealed class TeklifKarsilastirmaViewModel{public string? TalepNo{get;init;}public TalepFormModel? Talep{get;init;}public IReadOnlyList<KarsilastirmaTeklifi>Teklifler{get;init;}=[];}
public sealed record OnayBekleyenTeklif(int TeklifId,string TeklifNo,string TalepNo,string UrunAdi,string TalepEden,string FirmaAdi,decimal TeklifTutari,string ParaBirimi,int TeslimSuresiGun,DateTime TeklifTarihi,DateTime? GecerlilikTarihi);
