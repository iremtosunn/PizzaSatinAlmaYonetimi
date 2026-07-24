using System.ComponentModel.DataAnnotations;
namespace PizzaSatinAlmaYonetimi.Web.Models;
public sealed record TeslimatSatiri(int SiparisId,string SiparisNo,string TalepNo,string UrunAdi,string Tedarikci,decimal SiparisMiktari,string Birim,DateTime BeklenenTeslimTarihi,string Durum,DateTime? GercekTeslimTarihi,decimal? TeslimEdilenMiktar,decimal? KusurluMiktar);
public sealed class TeslimatKayitModel{[Required]public int SiparisId{get;set;}[Required,DataType(DataType.Date)]public DateTime? GercekTeslimTarihi{get;set;}[Required,Range(0.01d,9999999999999999d)]public decimal? TeslimEdilenMiktar{get;set;}[Required,Range(0d,9999999999999999d)]public decimal? KusurluMiktar{get;set;}}
public sealed class TeslimatTakibiViewModel{public IReadOnlyList<TeslimatSatiri>Teslimatlar{get;init;}=[];public TeslimatSatiri? SeciliSiparis{get;init;}public TeslimatKayitModel Form{get;init;}=new();public string? Arama{get;init;}public string? Durum{get;init;}}
