using System.ComponentModel.DataAnnotations;

namespace PizzaSatinAlmaYonetimi.Web.Models;

public sealed record KullaniciListeSatiri(int KullaniciId, string AdSoyad, string KullaniciAdi, string Eposta, string RolAdi, string Durum, DateTime? SonGirisTarihi, DateTime KayitTarihi);
public sealed record KullaniciOzet(int ToplamKullanici, int AktifKullanici, int PasifKullanici, int ToplamRol);
public sealed record RolSecenegi(int RolId, string RolAdi);

public sealed class KullaniciFiltreModel
{
    public string? AramaMetni { get; set; }
    public string? RolAdi { get; set; }
    public int? Durum { get; set; }
    [DataType(DataType.Date)] public DateTime? BaslangicTarihi { get; set; }
    [DataType(DataType.Date)] public DateTime? BitisTarihi { get; set; }
}

public sealed class KullaniciFormModel
{
    public int? KullaniciId { get; set; }
    [Required(ErrorMessage="Ad Soyad zorunludur.")][StringLength(100)] public string AdSoyad { get; set; } = string.Empty;
    [Required(ErrorMessage="Kullanıcı adı zorunludur.")][StringLength(50)] public string KullaniciAdi { get; set; } = string.Empty;
    [Required(ErrorMessage="E-posta zorunludur.")][EmailAddress(ErrorMessage="Geçerli bir e-posta adresi girin.")][StringLength(254)] public string Eposta { get; set; } = string.Empty;
    [Required(ErrorMessage="Rol seçimi zorunludur.")] public string RolAdi { get; set; } = string.Empty;
    [DataType(DataType.Password)][StringLength(100, MinimumLength=8, ErrorMessage="Geçici şifre en az 8 karakter olmalıdır.")] public string? GeciciSifre { get; set; }
    [DataType(DataType.Password)][Compare(nameof(GeciciSifre), ErrorMessage="Geçici şifreler eşleşmiyor.")] public string? GeciciSifreTekrar { get; set; }
}

public sealed class KullaniciYonetimiViewModel
{
    public IReadOnlyList<KullaniciListeSatiri> Kullanicilar { get; init; } = [];
    public IReadOnlyList<RolSecenegi> Roller { get; init; } = [];
    public KullaniciOzet Ozet { get; init; } = new(0,0,0,0);
    public KullaniciFiltreModel Filtre { get; init; } = new();
    public KullaniciFormModel Form { get; init; } = new();
    public string? AcikPanel { get; init; }
}
