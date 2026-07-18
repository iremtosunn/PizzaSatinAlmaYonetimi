using System.Data;
using Microsoft.Data.SqlClient;
using PizzaSatinAlmaYonetimi.Web.Data;
using PizzaSatinAlmaYonetimi.Web.Models;

namespace PizzaSatinAlmaYonetimi.Web.Services;

public sealed class KullaniciYonetimiService(ISqlConnectionFactory connectionFactory, ISifreDogrulamaService sifreService) : IKullaniciYonetimiService
{
    public async Task<IReadOnlyList<KullaniciListeSatiri>> ListeleAsync(KullaniciFiltreModel? filtre, CancellationToken cancellationToken)
    {
        await using var connection = connectionFactory.CreateConnection(); await connection.OpenAsync(cancellationToken);
        var filtreli = filtre is not null && (filtre.AramaMetni is not null || filtre.RolAdi is not null || filtre.Durum.HasValue || filtre.BaslangicTarihi.HasValue || filtre.BitisTarihi.HasValue);
        await using var command = Komut(connection, filtreli ? "dbo.sp_KullanicilariFiltrele" : "dbo.sp_KullanicilariListele");
        if (filtreli)
        {
            Ekle(command, "@AramaMetni", SqlDbType.NVarChar, filtre!.AramaMetni, 150); Ekle(command, "@RolAdi", SqlDbType.NVarChar, filtre.RolAdi, 100);
            Ekle(command, "@Durum", SqlDbType.Int, filtre.Durum); Ekle(command, "@BaslangicTarihi", SqlDbType.Date, filtre.BaslangicTarihi); Ekle(command, "@BitisTarihi", SqlDbType.Date, filtre.BitisTarihi);
        }
        var result = new List<KullaniciListeSatiri>();
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            if (reader.GetString("RolAdi") == "Tedarikçi") continue;
            result.Add(new(reader.GetInt32("KullaniciID"), reader.GetString("AdSoyad"), reader.GetString("KullaniciAdi"), reader.GetString("Eposta"), reader.GetString("RolAdi"), reader.GetString("Durum"),
                reader.IsDBNull("SonGirisTarihi") ? null : reader.GetDateTime("SonGirisTarihi"), reader.GetDateTime("KayitTarihi")));
        }
        return result;
    }

    public async Task<KullaniciOzet> OzetGetirAsync(CancellationToken cancellationToken)
    {
        await using var connection = connectionFactory.CreateConnection(); await connection.OpenAsync(cancellationToken);
        await using var command = Komut(connection, "dbo.sp_KullaniciYonetimiOzet"); await using var reader = await command.ExecuteReaderAsync(CommandBehavior.SingleRow, cancellationToken);
        return await reader.ReadAsync(cancellationToken) ? new(reader.GetInt32("ToplamKullanici"), reader.GetInt32("AktifKullanici"), reader.GetInt32("PasifKullanici"), reader.GetInt32("ToplamRol")) : new(0,0,0,0);
    }

    public async Task<IReadOnlyList<RolSecenegi>> RolleriGetirAsync(CancellationToken cancellationToken)
    {
        await using var connection = connectionFactory.CreateConnection(); await connection.OpenAsync(cancellationToken);
        await using var command = Komut(connection, "dbo.sp_RolleriListele"); await using var reader = await command.ExecuteReaderAsync(cancellationToken); var result = new List<RolSecenegi>();
        while (await reader.ReadAsync(cancellationToken)) if (reader.GetString("RolAdi") != "Tedarikçi") result.Add(new(reader.GetInt32("RolID"), reader.GetString("RolAdi"))); return result;
    }

    public async Task<KullaniciFormModel?> DetayGetirAsync(int kullaniciId, CancellationToken cancellationToken)
    {
        await using var connection = connectionFactory.CreateConnection(); await connection.OpenAsync(cancellationToken);
        await using var command = Komut(connection, "dbo.sp_KullaniciDetayiGetir"); Ekle(command, "@KullaniciID", SqlDbType.Int, kullaniciId);
        await using var reader = await command.ExecuteReaderAsync(CommandBehavior.SingleRow, cancellationToken);
        return await reader.ReadAsync(cancellationToken) ? new() { KullaniciId=reader.GetInt32("KullaniciID"), AdSoyad=reader.GetString("AdSoyad"), KullaniciAdi=reader.GetString("KullaniciAdi"), Eposta=reader.GetString("Eposta"), RolAdi=reader.GetString("RolAdi") } : null;
    }

    public async Task EkleAsync(KullaniciFormModel model, CancellationToken cancellationToken)
    {
        TedarikciRolunuEngelle(model);
        if (string.IsNullOrWhiteSpace(model.GeciciSifre)) throw new InvalidOperationException("Yeni kullanıcı için geçici şifre zorunludur.");
        var (hash, salt) = sifreService.HashOlustur(model.GeciciSifre);
        await using var connection = connectionFactory.CreateConnection(); await connection.OpenAsync(cancellationToken); await using var command = Komut(connection, "dbo.sp_KullaniciEkle");
        KullaniciAlanlari(command, model); Ekle(command,"@SifreHash",SqlDbType.VarBinary,hash); Ekle(command,"@SifreSalt",SqlDbType.VarBinary,salt); await command.ExecuteNonQueryAsync(cancellationToken);
    }

    public async Task GuncelleAsync(KullaniciFormModel model, CancellationToken cancellationToken)
    {
        TedarikciRolunuEngelle(model);
        if (!model.KullaniciId.HasValue) throw new InvalidOperationException("Kullanıcı ID zorunludur.");
        await using var connection = connectionFactory.CreateConnection(); await connection.OpenAsync(cancellationToken); await using var transaction = await connection.BeginTransactionAsync(cancellationToken);
        try {
            await using (var command = Komut(connection,"dbo.sp_KullaniciGuncelle",(SqlTransaction)transaction)) { Ekle(command,"@KullaniciID",SqlDbType.Int,model.KullaniciId); KullaniciAlanlari(command,model); await command.ExecuteNonQueryAsync(cancellationToken); }
            if (!string.IsNullOrWhiteSpace(model.GeciciSifre)) { var (hash,salt)=sifreService.HashOlustur(model.GeciciSifre); await using var password=Komut(connection,"dbo.sp_SifreGuncelle",(SqlTransaction)transaction); Ekle(password,"@KullaniciID",SqlDbType.Int,model.KullaniciId); Ekle(password,"@YeniSifreHash",SqlDbType.VarBinary,hash); Ekle(password,"@YeniSifreSalt",SqlDbType.VarBinary,salt); await password.ExecuteNonQueryAsync(cancellationToken); }
            await transaction.CommitAsync(cancellationToken);
        } catch { await transaction.RollbackAsync(cancellationToken); throw; }
    }

    public async Task DurumGuncelleAsync(int kullaniciId, int yeniDurum, CancellationToken cancellationToken)
    {
        await using var connection=connectionFactory.CreateConnection(); await connection.OpenAsync(cancellationToken); await using var command=Komut(connection,"dbo.sp_KullaniciDurumuGuncelle"); Ekle(command,"@KullaniciID",SqlDbType.Int,kullaniciId); Ekle(command,"@YeniDurum",SqlDbType.Int,yeniDurum); await command.ExecuteNonQueryAsync(cancellationToken);
    }

    private static SqlCommand Komut(SqlConnection c,string ad,SqlTransaction? t=null)=>new(ad,c,t){CommandType=CommandType.StoredProcedure};
    private static void Ekle(SqlCommand c,string ad,SqlDbType tip,object? deger,int? boyut=null){var p=boyut.HasValue?c.Parameters.Add(ad,tip,boyut.Value):c.Parameters.Add(ad,tip);p.Value=deger??DBNull.Value;}
    private static void KullaniciAlanlari(SqlCommand c,KullaniciFormModel m){Ekle(c,"@RolAdi",SqlDbType.NVarChar,m.RolAdi,100);Ekle(c,"@AdSoyad",SqlDbType.NVarChar,m.AdSoyad,150);Ekle(c,"@KullaniciAdi",SqlDbType.NVarChar,m.KullaniciAdi,100);Ekle(c,"@Eposta",SqlDbType.NVarChar,m.Eposta,150);}
    private static void TedarikciRolunuEngelle(KullaniciFormModel model){if(string.Equals(model.RolAdi,"Tedarikçi",StringComparison.OrdinalIgnoreCase))throw new InvalidOperationException("Tedarikçiler kullanıcı hesabı olarak tanımlanamaz.");}
}
