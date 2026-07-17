using System.ComponentModel.DataAnnotations;

namespace PizzaSatinAlmaYonetimi.Web.Models;

public sealed record RolListeSatiri(int RolId, string RolAdi, string? Aciklama, int KullaniciSayisi);
public sealed record RolYetkisi(int YetkiId, string YetkiKodu, string YetkiAdi, string? Aciklama, bool SeciliMi);
public sealed class RolFormModel
{
    public int? RolId { get; set; }
    [Required(ErrorMessage="Rol adı zorunludur.")][StringLength(100)] public string RolAdi { get; set; } = string.Empty;
    [StringLength(500)] public string? Aciklama { get; set; }
}
public sealed class RolYetkiFormModel
{
    public int RolId { get; set; }
    public List<int> YetkiIdleri { get; set; } = [];
}
public sealed class RolYonetimiViewModel
{
    public IReadOnlyList<RolListeSatiri> Roller { get; init; } = [];
    public IReadOnlyList<RolYetkisi> Yetkiler { get; init; } = [];
    public int? SeciliRolId { get; init; }
    public string? AramaMetni { get; init; }
    public RolFormModel Form { get; init; } = new();
    public string? AcikPanel { get; init; }
}
