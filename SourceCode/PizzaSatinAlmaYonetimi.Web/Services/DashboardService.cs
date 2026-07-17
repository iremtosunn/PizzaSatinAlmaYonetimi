using System.Data;
using Microsoft.Data.SqlClient;
using PizzaSatinAlmaYonetimi.Web.Data;
using PizzaSatinAlmaYonetimi.Web.Models;

namespace PizzaSatinAlmaYonetimi.Web.Services;

public sealed class DashboardService(ISqlConnectionFactory connectionFactory) : IDashboardService
{
    public async Task<DashboardViewModel> GetirAsync(int? kullaniciId, CancellationToken cancellationToken)
    {
        await using var connection = connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var (aktifTedarikci, toplamSiparis) = await OzetGetirAsync(connection, kullaniciId, cancellationToken);
        var talepDurumlari = await TalepDurumlariGetirAsync(connection, cancellationToken);
        var teklifDurumlari = await TeklifToplamiGetirAsync(connection, cancellationToken);
        var aylikOzet = await AylikOzetGetirAsync(connection, cancellationToken);
        var sonTalepler = await SonTaleplerGetirAsync(connection, cancellationToken);

        return new DashboardViewModel
        {
            Ozet = new(talepDurumlari.Sum(x => x.TalepSayisi), teklifDurumlari, aktifTedarikci, toplamSiparis),
            TalepDurumlari = talepDurumlari,
            AylikOzet = aylikOzet,
            SonTalepler = sonTalepler
        };
    }

    private static async Task<(int AktifTedarikci, int ToplamSiparis)> OzetGetirAsync(
        SqlConnection connection, int? kullaniciId, CancellationToken cancellationToken)
    {
        await using var command = Komut(connection, "dbo.sp_DashboardOzet");
        command.Parameters.Add("@KullaniciID", SqlDbType.Int).Value = kullaniciId ?? (object)DBNull.Value;
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken)) return (0, 0);
        return (Int(reader, "AktifTedarikciSayisi"), Int(reader, "ToplamSiparisSayisi"));
    }

    private static async Task<List<DashboardDurumSatiri>> TalepDurumlariGetirAsync(
        SqlConnection connection, CancellationToken cancellationToken)
    {
        await using var command = Komut(connection, "dbo.sp_DashboardTalepDurumDagilimi");
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        var result = new List<DashboardDurumSatiri>();
        while (await reader.ReadAsync(cancellationToken))
            result.Add(new(reader.GetString(reader.GetOrdinal("Durum")), Int(reader, "TalepSayisi")));
        return result;
    }

    private static async Task<int> TeklifToplamiGetirAsync(SqlConnection connection, CancellationToken cancellationToken)
    {
        await using var command = Komut(connection, "dbo.sp_DashboardTeklifDurumDagilimi");
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        var toplam = 0;
        while (await reader.ReadAsync(cancellationToken)) toplam += Int(reader, "TeklifSayisi");
        return toplam;
    }

    private static async Task<List<DashboardAylikOzetSatiri>> AylikOzetGetirAsync(
        SqlConnection connection, CancellationToken cancellationToken)
    {
        await using var command = Komut(connection, "dbo.sp_DashboardAylikTalepTeklifOzeti");
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        var result = new List<DashboardAylikOzetSatiri>();
        while (await reader.ReadAsync(cancellationToken))
            result.Add(new(reader.GetDateTime(reader.GetOrdinal("AyBaslangici")), Int(reader, "TalepSayisi"), Int(reader, "TeklifSayisi")));
        return result;
    }

    private static async Task<List<DashboardSonTalepSatiri>> SonTaleplerGetirAsync(
        SqlConnection connection, CancellationToken cancellationToken)
    {
        await using var command = Komut(connection, "dbo.sp_DashboardSonTalepler");
        command.Parameters.Add("@KayitSayisi", SqlDbType.Int).Value = 5;
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        var result = new List<DashboardSonTalepSatiri>();
        while (await reader.ReadAsync(cancellationToken))
            result.Add(new(
                reader.GetString(reader.GetOrdinal("TalepNo")), reader.GetString(reader.GetOrdinal("UrunAdi")),
                reader.GetDecimal(reader.GetOrdinal("Miktar")), reader.GetString(reader.GetOrdinal("Birim")),
                reader.GetString(reader.GetOrdinal("TalepEden")), reader.GetDateTime(reader.GetOrdinal("TalepTarihi")),
                reader.GetString(reader.GetOrdinal("Durum"))));
        return result;
    }

    private static int Int(SqlDataReader reader, string column) => Convert.ToInt32(reader.GetValue(reader.GetOrdinal(column)));
    private static SqlCommand Komut(SqlConnection connection, string name) =>
        new(name, connection) { CommandType = CommandType.StoredProcedure };
}
