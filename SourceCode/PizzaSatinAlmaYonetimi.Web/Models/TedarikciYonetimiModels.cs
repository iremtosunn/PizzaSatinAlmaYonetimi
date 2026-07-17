using System.ComponentModel.DataAnnotations;
namespace PizzaSatinAlmaYonetimi.Web.Models;
public sealed record TedarikciListeSatiri(int TedarikciId,string FirmaAdi,string VergiNo,string? Telefon,string? Eposta,string? Adres,string Durum,DateTime KayitTarihi);
public sealed class TedarikciFiltreModel{public string? AramaMetni{get;set;}public int? Durum{get;set;}[DataType(DataType.Date)]public DateTime? BaslangicTarihi{get;set;}[DataType(DataType.Date)]public DateTime? BitisTarihi{get;set;}}
public sealed class TedarikciFormModel
{
 public int? TedarikciId{get;set;}
 [Required(ErrorMessage="Firma adı zorunludur.")][StringLength(150)]public string FirmaAdi{get;set;}=string.Empty;
 [Required(ErrorMessage="Vergi numarası zorunludur.")][StringLength(20)]public string VergiNo{get;set;}=string.Empty;
 [StringLength(30)]public string? Telefon{get;set;}
 [EmailAddress(ErrorMessage="Geçerli bir e-posta adresi girin.")][StringLength(150)]public string? Eposta{get;set;}
 [StringLength(500)]public string? Adres{get;set;}
}
public sealed class TedarikciYonetimiViewModel{public IReadOnlyList<TedarikciListeSatiri>Tedarikciler{get;init;}=[];public TedarikciFiltreModel Filtre{get;init;}=new();public TedarikciFormModel Form{get;init;}=new();public string? AcikPanel{get;init;}}
