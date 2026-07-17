using System.Data;
using System.Globalization;
using Microsoft.Data.SqlClient;
using PizzaSatinAlmaYonetimi.Web.Data;
using PizzaSatinAlmaYonetimi.Web.Models;

namespace PizzaSatinAlmaYonetimi.Web.Services;

public sealed class RaporlarService(ISqlConnectionFactory connectionFactory) : IRaporlarService
{
    private static readonly IReadOnlyDictionary<string, string> Prosedurler = new Dictionary<string, string>
    {
        [RaporTurleri.AylikTalep] = "dbo.sp_RaporAylikTalep",
        [RaporTurleri.AylikTeklif] = "dbo.sp_RaporAylikTeklif",
        [RaporTurleri.EnCokTeklifVerenFirmalar] = "dbo.sp_RaporEnCokTeklifVerenFirmalar",
        [RaporTurleri.EnCokSatinAlmaYapilanFirmalar] = "dbo.sp_RaporEnCokSatinAlmaYapilanFirmalar",
        [RaporTurleri.YaklasanTeklifler] = "dbo.sp_RaporYaklasanTeklifler",
        [RaporTurleri.KullaniciTalepSayisi] = "dbo.sp_RaporKullaniciTalepSayisi",
        [RaporTurleri.AylikSatinAlmaTutari] = "dbo.sp_RaporAylikSatinAlmaTutari",
        [RaporTurleri.TalepDurumlari] = "dbo.sp_RaporTalepDurumlari",
        [RaporTurleri.TeklifDurumlari] = "dbo.sp_RaporTeklifDurumlari",
        [RaporTurleri.SiparisDurumlari] = "dbo.sp_RaporSiparisDurumlari"
    };

    public async Task<RaporlarViewModel> GetirAsync(string? raporTuru, CancellationToken cancellationToken)
    {
        var secim = Prosedurler.ContainsKey(raporTuru ?? string.Empty) ? raporTuru! : RaporTurleri.AylikTalep;
        await using var connection = connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        await using var command = new SqlCommand(Prosedurler[secim], connection) { CommandType = CommandType.StoredProcedure };
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);

        var columns = Enumerable.Range(0, reader.FieldCount).Select(reader.GetName).ToArray();
        var rows = new List<IReadOnlyList<string>>();
        while (await reader.ReadAsync(cancellationToken))
        {
            var row = new string[reader.FieldCount];
            for (var index = 0; index < reader.FieldCount; index++) row[index] = DegerMetni(reader.GetValue(index));
            rows.Add(row);
        }

        return new RaporlarViewModel { RaporTuru = secim, Sutunlar = columns, Satirlar = rows };
    }

    private static string DegerMetni(object value) => value switch
    {
        DBNull => "",
        DateTime date => date.ToString("dd.MM.yyyy", CultureInfo.GetCultureInfo("tr-TR")),
        decimal amount => amount.ToString("N2", CultureInfo.GetCultureInfo("tr-TR")),
        _ => Convert.ToString(value, CultureInfo.GetCultureInfo("tr-TR")) ?? string.Empty
    };
}
