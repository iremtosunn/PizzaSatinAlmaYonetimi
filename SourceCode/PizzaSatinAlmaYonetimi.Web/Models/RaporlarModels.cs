using System;
using System.Collections.Generic;

namespace PizzaSatinAlmaYonetimi.Web.Models;

public sealed class RaporlarViewModel
{
    public RaporlarViewModel()
    {
        RaporTuru = RaporTurSecenekleri.AylikTalep;
        RaporTurleri = RaporTurSecenekleri.Tum;
    }

    public string RaporTuru { get; set; }

    public IReadOnlyList<RaporSecenegi> RaporTurleri { get; set; }

    public IReadOnlyList<string> Sutunlar { get; set; } = Array.Empty<string>();

    public IReadOnlyList<IReadOnlyList<string>> Satirlar { get; set; } = Array.Empty<IReadOnlyList<string>>();

    public string? HataMesaji { get; set; }
    public RaporKpi Kpi { get; set; } = new();
    public IReadOnlyList<RaporGrafikNoktasi> AylikHarcama { get; set; } = Array.Empty<RaporGrafikNoktasi>();
    public IReadOnlyList<RaporGrafikNoktasi> TalepDurumDagilimi { get; set; } = Array.Empty<RaporGrafikNoktasi>();
    public IReadOnlyList<RaporTedarikciOzeti> EnYuksekHarcamaTedarikcileri { get; set; } = Array.Empty<RaporTedarikciOzeti>();
    public RaporTeslimatOzeti Teslimat { get; set; } = new();
}

public sealed class RaporKpi{public int ToplamTalep{get;set;}public int ToplamTeklif{get;set;}public int ToplamSiparis{get;set;}public int AktifTedarikci{get;set;}public decimal ToplamHarcama{get;set;}public int OncelikliTalep{get;set;}}
public sealed record RaporGrafikNoktasi(string Etiket,decimal Deger);
public sealed record RaporTedarikciOzeti(string FirmaAdi,int SiparisSayisi,decimal ToplamTutar);
public sealed class RaporTeslimatOzeti{public int Tamamlanan{get;set;}public int Geciken{get;set;}public decimal ZamanindaOrani{get;set;}public decimal KusurOrani{get;set;}}

public sealed record RaporSecenegi(string Deger, string Metin);

public static class RaporTurSecenekleri
{
    public const string AylikTalep = "AylikTalep";
    public const string AylikTeklif = "AylikTeklif";
    public const string AylikSatinAlmaTutari = "AylikSatinAlmaTutari";
    public const string EnCokSatinAlmaYapilanFirmalar = "EnCokSatinAlmaYapilanFirmalar";
    public const string EnCokTeklifVerenFirmalar = "EnCokTeklifVerenFirmalar";
    public const string KullaniciTalepSayisi = "KullaniciTalepSayisi";
    public const string SiparisDurumlari = "SiparisDurumlari";
    public const string TalepDurumlari = "TalepDurumlari";
    public const string TeklifDurumlari = "TeklifDurumlari";
    public const string YaklasanTeklifler = "YaklasanTeklifler";

    public static IReadOnlyList<RaporSecenegi> Tum { get; } = new List<RaporSecenegi>
    {
        new(AylikTalep, "Bu Ay Oluşturulan Satın Alma Talepleri"),
        new(AylikTeklif, "Bu Ay Gelen Teklif Sayısı"),
        new(AylikSatinAlmaTutari, "Aylık Satın Alma Tutarı"),
        new(EnCokSatinAlmaYapilanFirmalar, "En Çok Satın Alma Yapılan Firmalar"),
        new(EnCokTeklifVerenFirmalar, "En Çok Teklif Veren Firmalar"),
        new(KullaniciTalepSayisi, "Kullanıcı Bazlı Talep Sayısı"),
        new(SiparisDurumlari, "Sipariş Durumları"),
        new(TalepDurumlari, "Talep Durumları"),
        new(TeklifDurumlari, "Teklif Durumları"),
        new(YaklasanTeklifler, "Yaklaşan Teklifler")
    };
}

public static class RaporTurleri
{
    public const string AylikTalep = RaporTurSecenekleri.AylikTalep;
    public const string AylikTeklif = RaporTurSecenekleri.AylikTeklif;
    public const string AylikSatinAlmaTutari = RaporTurSecenekleri.AylikSatinAlmaTutari;
    public const string EnCokSatinAlmaYapilanFirmalar = RaporTurSecenekleri.EnCokSatinAlmaYapilanFirmalar;
    public const string EnCokTeklifVerenFirmalar = RaporTurSecenekleri.EnCokTeklifVerenFirmalar;
    public const string KullaniciTalepSayisi = RaporTurSecenekleri.KullaniciTalepSayisi;
    public const string SiparisDurumlari = RaporTurSecenekleri.SiparisDurumlari;
    public const string TalepDurumlari = RaporTurSecenekleri.TalepDurumlari;
    public const string TeklifDurumlari = RaporTurSecenekleri.TeklifDurumlari;
    public const string YaklasanTeklifler = RaporTurSecenekleri.YaklasanTeklifler;

    public static IReadOnlyList<RaporSecenegi> Tum => RaporTurSecenekleri.Tum;
}
