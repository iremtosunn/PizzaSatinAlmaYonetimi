using System.ComponentModel.DataAnnotations;

namespace PizzaSatinAlmaYonetimi.Web.Models;

public sealed class GirisViewModel
{
    [Required(ErrorMessage = "Kullanıcı adı zorunludur.")]
    [StringLength(50, ErrorMessage = "Kullanıcı adı en fazla 50 karakter olabilir.")]
    [Display(Name = "Kullanıcı Adı")]
    public string KullaniciAdi { get; set; } = string.Empty;

    [Required(ErrorMessage = "Şifre zorunludur.")]
    [DataType(DataType.Password)]
    [Display(Name = "Şifre")]
    public string Sifre { get; set; } = string.Empty;
}
