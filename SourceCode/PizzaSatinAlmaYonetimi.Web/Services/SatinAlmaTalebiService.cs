using System.Data;
using Microsoft.Data.SqlClient;
using PizzaSatinAlmaYonetimi.Web.Data;
using PizzaSatinAlmaYonetimi.Web.Models;

namespace PizzaSatinAlmaYonetimi.Web.Services;

public sealed class SatinAlmaTalebiService(ISqlConnectionFactory factory) : ISatinAlmaTalebiService
{
    public async Task<IReadOnlyList<TalepListeSatiri>> ListeleAsync(TalepFiltreModel? f, CancellationToken ct)
    {
        await using var c = factory.CreateConnection();
        await c.OpenAsync(ct);

        var filtreli = f is not null &&
            (
                !string.IsNullOrWhiteSpace(f.AramaMetni) ||
                !string.IsNullOrWhiteSpace(f.TalepEden) ||
                !string.IsNullOrWhiteSpace(f.Durumlar) ||
                f.BaslangicTarihi.HasValue ||
                f.BitisTarihi.HasValue
            );

        await using var cmd = Komut(c, filtreli ? "dbo.sp_TalepleriFiltrele" : "dbo.sp_TalepleriListele");

        if (filtreli)
        {
            P(cmd, "@AramaMetni", SqlDbType.NVarChar, f!.AramaMetni, 150);
            P(cmd, "@TalepEden", SqlDbType.NVarChar, f.TalepEden, 150);
            P(cmd, "@Durumlar", SqlDbType.NVarChar, f.Durumlar, 20);
            P(cmd, "@BaslangicTarihi", SqlDbType.Date, f.BaslangicTarihi);
            P(cmd, "@BitisTarihi", SqlDbType.Date, f.BitisTarihi);
            P(cmd, "@MinMiktar", SqlDbType.Decimal, null);
            P(cmd, "@MaxMiktar", SqlDbType.Decimal, null);
        }

        await using var r = await cmd.ExecuteReaderAsync(ct);

        var list = new List<TalepListeSatiri>();

        while (await r.ReadAsync(ct))
        {
            list.Add(new TalepListeSatiri(
                r.GetInt32("TalepID"),
                r.GetString("TalepNo"),
                r.GetString("UrunAdi"),
                r.GetDecimal(r.GetOrdinal("Miktar")),
                r.GetString("Birim"),
                r.GetString("TalepEden"),
                r.GetDateTime("TalepTarihi"),
                r.IsDBNull("Aciklama") ? null : r.GetString("Aciklama"),
                r.GetString("Durum")
            ));
        }

        return list;
    }

    public async Task<TalepFormModel?> DetayGetirAsync(string no, CancellationToken ct)
    {
        await using var c = factory.CreateConnection();
        await c.OpenAsync(ct);

        await using var cmd = Komut(c, "dbo.sp_TalepDetayiGetir");
        P(cmd, "@TalepNo", SqlDbType.NVarChar, no, 20);

        await using var r = await cmd.ExecuteReaderAsync(CommandBehavior.SingleRow, ct);

        if (!await r.ReadAsync(ct))
            return null;

        return new TalepFormModel
        {
            TalepId = r.GetInt32("TalepID"),
            TalepNo = r.GetString("TalepNo"),
            TalepEden = r.GetString("TalepEden"),
            UrunAdi = r.GetString("UrunAdi"),
            Miktar = r.GetDecimal(r.GetOrdinal("Miktar")),
            Birim = r.GetString("Birim"),
            Aciklama = r.IsDBNull("Aciklama") ? null : r.GetString("Aciklama")
        };
    }

    public async Task EkleAsync(int uid, TalepFormModel m, CancellationToken ct)
    {
        await using var c = factory.CreateConnection();
        await c.OpenAsync(ct);

        await using var cmd = Komut(c, "dbo.sp_TalepEkle");
        P(cmd, "@TalepEdenKullaniciID", SqlDbType.Int, uid);
        Alanlar(cmd, m, false);

        await cmd.ExecuteNonQueryAsync(ct);
    }

    public async Task GuncelleAsync(TalepFormModel m, CancellationToken ct)
    {
        if (!m.TalepId.HasValue)
            throw new InvalidOperationException("Talep ID zorunludur.");

        await using var c = factory.CreateConnection();
        await c.OpenAsync(ct);

        await using var cmd = Komut(c, "dbo.sp_TalepDuzenle");
        P(cmd, "@TalepID", SqlDbType.Int, m.TalepId);
        Alanlar(cmd, m, true);

        await cmd.ExecuteNonQueryAsync(ct);
    }

    public async Task ReddetAsync(string no, CancellationToken ct)
    {
        await using var c = factory.CreateConnection();
        await c.OpenAsync(ct);

        await using var cmd = Komut(c, "dbo.sp_TalebiReddet");
        P(cmd, "@TalepNo", SqlDbType.NVarChar, no, 20);

        await cmd.ExecuteNonQueryAsync(ct);
    }

    public async Task GeriAlAsync(string no, CancellationToken ct)
    {
        await using var c = factory.CreateConnection();
        await c.OpenAsync(ct);

        await using var cmd = Komut(c, "dbo.sp_TalepGeriAl");
        P(cmd, "@TalepNo", SqlDbType.NVarChar, no, 20);

        await cmd.ExecuteNonQueryAsync(ct);
    }

    private static void Alanlar(SqlCommand c, TalepFormModel m, bool duzenle)
    {
        P(c, "@UrunAdi", SqlDbType.NVarChar, m.UrunAdi, 150);
        P(c, duzenle ? "@UrunAciklamasi" : "@Aciklama", SqlDbType.NVarChar, m.Aciklama, duzenle ? 255 : 500);
        P(c, "@Miktar", SqlDbType.Decimal, m.Miktar);
        c.Parameters["@Miktar"].Precision = 18;
        c.Parameters["@Miktar"].Scale = 2;
        P(c, "@Birim", SqlDbType.NVarChar, m.Birim, duzenle ? 20 : 30);
    }

    private static SqlCommand Komut(SqlConnection c, string ad)
        => new(ad, c) { CommandType = CommandType.StoredProcedure };

    private static void P(SqlCommand c, string ad, SqlDbType tip, object? deger, int? boyut = null)
    {
        var p = boyut.HasValue
            ? c.Parameters.Add(ad, tip, boyut.Value)
            : c.Parameters.Add(ad, tip);

        p.Value = deger ?? DBNull.Value;
    }
}