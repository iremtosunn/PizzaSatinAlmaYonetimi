namespace PizzaSatinAlmaYonetimi.Web.Models;

public sealed class DashboardViewModel
{
    public DashboardOzet Ozet { get; init; } = new(0, 0, 0, 0);
    public IReadOnlyList<DashboardDurumSatiri> TalepDurumlari { get; init; } = [];
    public IReadOnlyList<DashboardAylikOzetSatiri> AylikOzet { get; init; } = [];
    public IReadOnlyList<DashboardSonTalepSatiri> SonTalepler { get; init; } = [];
    public string? HataMesaji { get; init; }
}

public sealed record DashboardOzet(int ToplamTalep, int ToplamTeklif, int AktifTedarikci, int ToplamSiparis);
public sealed record DashboardDurumSatiri(string Durum, int TalepSayisi);
public sealed record DashboardAylikOzetSatiri(DateTime AyBaslangici, int TalepSayisi, int TeklifSayisi);
public sealed record DashboardSonTalepSatiri(
    string TalepNo, string UrunAdi, decimal Miktar, string Birim,
    string TalepEden, DateTime TalepTarihi, string Durum);
