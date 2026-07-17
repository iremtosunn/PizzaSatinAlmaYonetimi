using System.ComponentModel.DataAnnotations;
namespace PizzaSatinAlmaYonetimi.Web.Models;
public sealed record TeklifListeSatiri(int TeklifId,string TeklifNo,string TalepNo,string UrunAdi,string? Aciklama,string FirmaAdi,decimal? BirimFiyat,decimal TeklifTutari,string ParaBirimi,int TeslimSuresiGun,DateTime? Skt,DateTime TeklifTarihi,DateTime? GecerlilikTarihi,string Durum);
public sealed record TeklifTalepSecenegi(string TalepNo,string UrunAdi);public sealed record TeklifTedarikciSecenegi(int TedarikciId,string FirmaAdi);
public sealed class TeklifFiltreModel{public string? AramaMetni{get;set;}public string? FirmaAdi{get;set;}public string? Durumlar{get;set;}[DataType(DataType.Date)]public DateTime? BaslangicTarihi{get;set;}[DataType(DataType.Date)]public DateTime? BitisTarihi{get;set;}public decimal? MinTutar{get;set;}public decimal? MaxTutar{get;set;}}
public sealed class TeklifFormModel
{
 public int? TeklifId{get;set;}public string? TeklifNo{get;set;}public string? UrunAdi{get;set;}public string? Aciklama{get;set;}public decimal? BirimFiyat{get;set;}public DateTime? TeklifTarihi{get;set;}public string? Durum{get;set;}
 [Required(ErrorMessage="Talep seçimi zorunludur.")]public string TalepNo{get;set;}=string.Empty;
 public int? TedarikciId{get;set;}[Required(ErrorMessage="Tedarikçi seçimi zorunludur.")]public string FirmaAdi{get;set;}=string.Empty;
 [Range(typeof(decimal),"0.01","999999999.99",ErrorMessage="Tutar sıfırdan büyük olmalıdır.")]public decimal Tutar{get;set;}
 [Range(1,3650,ErrorMessage="Teslim süresi sıfırdan büyük olmalıdır.")]public int TeslimSuresiGun{get;set;}
 [DataType(DataType.Date)]public DateTime? Skt{get;set;}[Required(ErrorMessage="Geçerlilik tarihi zorunludur.")][DataType(DataType.Date)]public DateTime? GecerlilikTarihi{get;set;}
 [Required][StringLength(3,MinimumLength=3)]public string ParaBirimi{get;set;}="TRY";
}
public sealed class TeklifGirisiViewModel{public IReadOnlyList<TeklifListeSatiri>Teklifler{get;init;}=[];public IReadOnlyList<TeklifTalepSecenegi>Talepler{get;init;}=[];public IReadOnlyList<TeklifTedarikciSecenegi>Tedarikciler{get;init;}=[];public TeklifFiltreModel Filtre{get;init;}=new();public TeklifFormModel Form{get;init;}=new();public string? AcikPanel{get;init;}}
