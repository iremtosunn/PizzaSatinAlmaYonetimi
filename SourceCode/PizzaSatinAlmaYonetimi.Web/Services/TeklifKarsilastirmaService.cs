using System.Data;
using Microsoft.Data.SqlClient;
using PizzaSatinAlmaYonetimi.Web.Data;
using PizzaSatinAlmaYonetimi.Web.Models;

namespace PizzaSatinAlmaYonetimi.Web.Services;

public sealed class TeklifKarsilastirmaService(ISqlConnectionFactory factory,ITedarikciPuanService puanService) : ITeklifKarsilastirmaService
{
    public async Task<IReadOnlyList<KarsilastirmaTeklifi>> ListeleAsync(string no, CancellationToken ct)
    {
        await using var c = factory.CreateConnection();
        await c.OpenAsync(ct);

        await using var cmd = Komut(c, "dbo.sp_TalebeAitTeklifleriListele");
        P(cmd, "@TalepNo", no);

        await using var r = await cmd.ExecuteReaderAsync(ct);

        var liste = new List<KarsilastirmaTeklifi>();

        while (await r.ReadAsync(ct))
        {
            var durum = r.GetString("Durum");

            if (durum == "İnceleniyor")
                durum = "Girildi";

            liste.Add(new KarsilastirmaTeklifi(
                r.GetString("TeklifNo"),
                r.GetString("TalepNo"),
                r.GetString("UrunAdi"),
                r.GetString("TalepEden"),
                r.GetString("FirmaAdi"),
                r.GetDecimal(r.GetOrdinal("TeklifTutari")),
                r.GetString("ParaBirimi"),
                r.GetInt32("TeslimSuresiGun"),
                r.IsDBNull("SKT") ? null : r.GetDateTime("SKT"),
                r.IsDBNull("GecerlilikTarihi") ? null : r.GetDateTime("GecerlilikTarihi"),
                durum
            ));
        }

        var puanlar=(await puanService.GetirAsync(ct)).GroupBy(x=>x.FirmaAdi).ToDictionary(x=>x.Key,x=>x.First(),StringComparer.CurrentCultureIgnoreCase);
        return liste.Select(x=>puanlar.TryGetValue(x.FirmaAdi,out var p)?x with{TedarikciPuani=p.Puan,TamamlananTeslimat=p.TamamlananTeslimat}:x).ToList();
    }

    public Task SecAsync(string no, CancellationToken ct)
        => Calistir("dbo.sp_TeklifSec", no, ct);

    public Task ReddetAsync(string no, CancellationToken ct)
        => Calistir("dbo.sp_TeklifiReddet", no, ct);

    public Task GeriAlAsync(string no, CancellationToken ct)
        => Calistir("dbo.sp_TeklifiGeriAl", no, ct);

    private async Task Calistir(string procedureAdi, string teklifNo, CancellationToken ct)
    {
        await using var c = factory.CreateConnection();
        await c.OpenAsync(ct);

        await using var cmd = Komut(c, procedureAdi);
        P(cmd, "@TeklifNo", teklifNo);

        await cmd.ExecuteNonQueryAsync(ct);
    }

    private static SqlCommand Komut(SqlConnection c, string procedureAdi)
        => new(procedureAdi, c) { CommandType = CommandType.StoredProcedure };

    private static void P(SqlCommand c, string ad, string deger)
        => c.Parameters.Add(ad, SqlDbType.NVarChar, 20).Value = deger;
}
