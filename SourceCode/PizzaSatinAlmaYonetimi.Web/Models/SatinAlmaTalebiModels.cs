using System.ComponentModel.DataAnnotations;
namespace PizzaSatinAlmaYonetimi.Web.Models;

public sealed record TalepListeSatiri(int TalepId,string TalepNo,string UrunAdi,decimal Miktar,string Birim,string TalepEden,DateTime TalepTarihi,string? Aciklama,string Durum,int TalepDurumId,int TalepEdenKullaniciId);
public sealed class TalepFiltreModel{public string? AramaMetni{get;set;}public string? TalepEden{get;set;}public string? Durumlar{get;set;}[DataType(DataType.Date)]public DateTime? BaslangicTarihi{get;set;}[DataType(DataType.Date)]public DateTime? BitisTarihi{get;set;}}
public sealed class TalepFormModel
{
 public int? TalepId{get;set;}public string? TalepNo{get;set;}public string? TalepEden{get;set;}public DateTime? TalepTarihi{get;set;}public int? TalepDurumId{get;set;}public bool? ErtelenebilirMi{get;set;}
 [Required(ErrorMessage="Ürün adı zorunludur.")][StringLength(150)]public string UrunAdi{get;set;}=string.Empty;
 [Range(typeof(decimal),"1","99999999",ErrorMessage="Miktar sıfırdan büyük olmalıdır.")]public decimal Miktar{get;set;}
 [Required(ErrorMessage="Birim zorunludur.")][StringLength(20)]public string Birim{get;set;}=string.Empty;
 [StringLength(255)]public string? Aciklama{get;set;}
}
public sealed class TalepIncelemeModel
{
 [Required]public int TalepId{get;set;}
 [Range(0d,9999999999999999d,ErrorMessage="Depodaki mevcut miktar negatif olamaz.")]public decimal MevcutStokMiktari{get;set;}
 [Range(0,int.MaxValue,ErrorMessage="Stok yeterlilik süresi negatif olamaz.")]public int StokYeterlilikSuresiGun{get;set;}
 [Required(ErrorMessage="Ertelenebilir mi seçimi zorunludur.")]public bool? ErtelenebilirMi{get;set;}
}
public sealed class SatinAlmaTalepleriViewModel{public IReadOnlyList<TalepListeSatiri>Talepler{get;init;}=[];public TalepFiltreModel Filtre{get;init;}=new();public TalepFormModel Form{get;init;}=new();public TalepIncelemeModel Inceleme{get;init;}=new();public TalepFormModel? IncelenecekTalep{get;init;}public string? AcikPanel{get;init;}public int GirisYapanKullaniciId{get;init;}public int GirisYapanRolId{get;init;}}
