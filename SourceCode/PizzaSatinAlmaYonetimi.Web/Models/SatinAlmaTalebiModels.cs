using System.ComponentModel.DataAnnotations;
namespace PizzaSatinAlmaYonetimi.Web.Models;
public sealed record TalepListeSatiri(int TalepId,string TalepNo,string UrunAdi,decimal Miktar,string Birim,string TalepEden,DateTime TalepTarihi,string? Aciklama,string Durum,int TalepEdenKullaniciId=0);
public sealed class TalepFiltreModel{public string? AramaMetni{get;set;}public string? TalepEden{get;set;}public string? Durumlar{get;set;}[DataType(DataType.Date)]public DateTime? BaslangicTarihi{get;set;}[DataType(DataType.Date)]public DateTime? BitisTarihi{get;set;}}
public sealed class TalepFormModel
{
 public int? TalepId{get;set;}public string? TalepNo{get;set;}public string? TalepEden{get;set;}
 [Required(ErrorMessage="ÃœrÃ¼n adÄ± zorunludur.")][StringLength(150)]public string UrunAdi{get;set;}=string.Empty;
 [Range(typeof(decimal),"1","99999999",ErrorMessage="Miktar sıfırdan büyük olmalıdır.")]public decimal Miktar{get;set;}
 [Required(ErrorMessage="Birim zorunludur.")][StringLength(20)]public string Birim{get;set;}=string.Empty;
 [StringLength(255)]public string? Aciklama{get;set;}
}
public sealed class SatinAlmaTalepleriViewModel{public IReadOnlyList<TalepListeSatiri>Talepler{get;init;}=[];public TalepFiltreModel Filtre{get;init;}=new();public TalepFormModel Form{get;init;}=new();public string? AcikPanel{get;init;}public int GirisYapanKullaniciId{get;init;}}


