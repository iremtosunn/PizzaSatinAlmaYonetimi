namespace PizzaSatinAlmaYonetimi.Web.Models;

public sealed class RaporlarViewModel
{
    public string RaporTuru { get; init; } = RaporTurleri.AylikTalep;
    public IReadOnlyList<RaporSecenegi> RaporTurleri { get; init; } = RaporTurleri.Tum;
    public IReadOnlyList<string> Sutunlar { get; init; } = [];
    public IReadOnlyList<IReadOnlyList<string>> Satirlar { get; init; } = [];
    public string? HataMesaji { get; init; }
}

public sealed record RaporSecenegi(string Deger, string Metin);

public static class RaporTurleri
{
    public const string AylikTalep = "aylik-talep";
    public const string AylikTeklif = "aylik-teklif";
    public const string EnCokTeklifVerenFirmalar = "en-cok-teklif-veren-firmalar";
    public const string EnCokSatinAlmaYapilanFirmalar = "en-cok-satin-alma-yapilan-firmalar";
    public const string YaklasanTeklifler = "yaklasan-teklifler";
    public const string KullaniciTalepSayisi = "kullanici-talep-sayisi";
    public const string AylikSatinAlmaTutari = "aylik-satin-alma-tutari";
    public const string TalepDurumlari = "talep-durumlari";
    public const string TeklifDurumlari = "teklif-durumlari";
    public const string SiparisDurumlari = "siparis-durumlari";

    public static readonly IReadOnlyList<RaporSecenegi> Tum =
    [
        new(AylikTalep, "Aylık satın alma talepleri"),
        new(AylikTeklif, "Aylık gelen teklifler"),
        new(EnCokTeklifVerenFirmalar, "En çok teklif veren firmalar"),
        new(EnCokSatinAlmaYapilanFirmalar, "En çok satın alma yapılan firmalar"),
        new(YaklasanTeklifler, "Yaklaşan teklif tarihleri"),
        new(KullaniciTalepSayisi, "Kullanıcı bazlı talep sayısı"),
        new(AylikSatinAlmaTutari, "Aylık satın alma tutarı"),
        new(TalepDurumlari, "Talep durumları"),
        new(TeklifDurumlari, "Teklif durumları"),
        new(SiparisDurumlari, "Sipariş durumları")
    ];
}
