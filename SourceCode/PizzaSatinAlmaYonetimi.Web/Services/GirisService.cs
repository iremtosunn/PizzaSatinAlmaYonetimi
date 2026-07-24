using System.Data;
using Microsoft.Data.SqlClient;
using PizzaSatinAlmaYonetimi.Web.Data;
using PizzaSatinAlmaYonetimi.Web.Models;

namespace PizzaSatinAlmaYonetimi.Web.Services;

public sealed class GirisService(
    ISqlConnectionFactory connectionFactory,
    ISifreDogrulamaService sifreDogrulamaService) : IGirisService
{
    public async Task<OturumKullanicisi?> DogrulaAsync(string kullaniciAdi, string sifre, CancellationToken cancellationToken)
    {
        await using var connection = connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var kullanici = await KullaniciGetirAsync(connection, kullaniciAdi.Trim(), cancellationToken);
        if (kullanici is null || kullanici.Durum != 1 ||
            !sifreDogrulamaService.Dogrula(sifre, kullanici.SifreSalt, kullanici.SifreHash))
            return null;

        await SonGirisTarihiniGuncelleAsync(connection, kullanici.KullaniciId, cancellationToken);
        return new OturumKullanicisi(kullanici.KullaniciId, kullanici.RolId, kullanici.AdSoyad, kullanici.RolAdi);
    }

    private static async Task<GirisKullanicisi?> KullaniciGetirAsync(SqlConnection connection, string kullaniciAdi, CancellationToken cancellationToken)
    {
        await using var command = new SqlCommand("dbo.sp_GirisKullanicisiniGetir", connection)
        {
            CommandType = CommandType.StoredProcedure
        };
        command.Parameters.Add("@KullaniciAdi", SqlDbType.NVarChar, 100).Value = kullaniciAdi;

        await using var reader = await command.ExecuteReaderAsync(CommandBehavior.SingleRow, cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
            return null;

        return new GirisKullanicisi(
            reader.GetInt32(reader.GetOrdinal("KullaniciID")),
            reader.GetInt32(reader.GetOrdinal("RolID")),
            reader.GetString(reader.GetOrdinal("RolAdi")),
            reader.GetString(reader.GetOrdinal("AdSoyad")),
            reader.GetString(reader.GetOrdinal("KullaniciAdi")),
            (byte[])reader["SifreHash"],
            (byte[])reader["SifreSalt"],
            reader.GetInt32(reader.GetOrdinal("Durum")));
    }

    private static async Task SonGirisTarihiniGuncelleAsync(SqlConnection connection, int kullaniciId, CancellationToken cancellationToken)
    {
        await using var command = new SqlCommand("dbo.sp_SonGirisTarihiniGuncelle", connection)
        {
            CommandType = CommandType.StoredProcedure
        };
        command.Parameters.Add("@KullaniciID", SqlDbType.Int).Value = kullaniciId;
        await command.ExecuteNonQueryAsync(cancellationToken);
    }
}
