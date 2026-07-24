using System.Data;
using Microsoft.Data.SqlClient;
using PizzaSatinAlmaYonetimi.Web.Data;
using PizzaSatinAlmaYonetimi.Web.Models;
namespace PizzaSatinAlmaYonetimi.Web.Services;

public sealed class SatinAlmaTalebiService(ISqlConnectionFactory factory):ISatinAlmaTalebiService
{
 public async Task<IReadOnlyList<TalepListeSatiri>> ListeleAsync(TalepFiltreModel? f,CancellationToken ct)
 {
  await using var c=factory.CreateConnection();await c.OpenAsync(ct);
  var filtreli=f is not null&&(!string.IsNullOrWhiteSpace(f.AramaMetni)||!string.IsNullOrWhiteSpace(f.TalepEden)||!string.IsNullOrWhiteSpace(f.Durumlar)||f.BaslangicTarihi.HasValue||f.BitisTarihi.HasValue);
  await using var cmd=Komut(c,filtreli?"dbo.sp_TalepleriFiltrele":"dbo.sp_TalepleriListele");
  if(filtreli){P(cmd,"@AramaMetni",SqlDbType.NVarChar,f!.AramaMetni,150);P(cmd,"@TalepEden",SqlDbType.NVarChar,f.TalepEden,150);P(cmd,"@Durumlar",SqlDbType.NVarChar,f.Durumlar,20);P(cmd,"@BaslangicTarihi",SqlDbType.Date,f.BaslangicTarihi);P(cmd,"@BitisTarihi",SqlDbType.Date,f.BitisTarihi);P(cmd,"@MinMiktar",SqlDbType.Decimal,null);P(cmd,"@MaxMiktar",SqlDbType.Decimal,null);}
  var ham=new List<(int Id,string No,string Urun,decimal Miktar,string Birim,string Eden,DateTime Tarih,string? Aciklama,string Durum)>();
  await using(var r=await cmd.ExecuteReaderAsync(ct))while(await r.ReadAsync(ct))ham.Add((r.GetInt32("TalepID"),r.GetString("TalepNo"),r.GetString("UrunAdi"),r.GetDecimal(r.GetOrdinal("Miktar")),r.GetString("Birim"),r.GetString("TalepEden"),r.GetDateTime("TalepTarihi"),r.IsDBNull("Aciklama")?null:r.GetString("Aciklama"),r.GetString("Durum")));
  await using var ek=new SqlCommand("SELECT TalepID,TalepDurumID,TalepEdenKullaniciID FROM dbo.SatinAlmaTalepleri",c);
  await using var er=await ek.ExecuteReaderAsync(ct);var meta=new Dictionary<int,(int Durum,int Sahip)>();while(await er.ReadAsync(ct))meta[er.GetInt32(0)]=(er.GetInt32(1),er.GetInt32(2));
  return ham.Select(x=>new TalepListeSatiri(x.Id,x.No,x.Urun,x.Miktar,x.Birim,x.Eden,x.Tarih,x.Aciklama,x.Durum,meta[x.Id].Durum,meta[x.Id].Sahip)).ToList();
 }
 public async Task<TalepFormModel?> DetayGetirAsync(string no,CancellationToken ct)
 {
  await using var c=factory.CreateConnection();await c.OpenAsync(ct);
  await using var cmd=new SqlCommand("SELECT SAT.TalepID,SAT.TalepNo,SAT.UrunAdi,SAT.Miktar,SAT.Birim,SAT.Aciklama,SAT.TalepTarihi,SAT.TalepDurumID,SAT.ErtelenebilirMi,K.AdSoyad AS TalepEden FROM dbo.SatinAlmaTalepleri SAT INNER JOIN dbo.Kullanicilar K ON K.KullaniciID=SAT.TalepEdenKullaniciID WHERE SAT.TalepNo=@TalepNo",c);
  P(cmd,"@TalepNo",SqlDbType.NVarChar,no,20);await using var r=await cmd.ExecuteReaderAsync(CommandBehavior.SingleRow,ct);
  return await r.ReadAsync(ct)?new(){TalepId=r.GetInt32("TalepID"),TalepNo=r.GetString("TalepNo"),TalepEden=r.GetString("TalepEden"),UrunAdi=r.GetString("UrunAdi"),Miktar=r.GetDecimal(r.GetOrdinal("Miktar")),Birim=r.GetString("Birim"),Aciklama=r.IsDBNull("Aciklama")?null:r.GetString("Aciklama"),TalepTarihi=r.GetDateTime("TalepTarihi"),TalepDurumId=r.GetInt32("TalepDurumID"),ErtelenebilirMi=r.IsDBNull("ErtelenebilirMi")?null:r.GetBoolean("ErtelenebilirMi")}:null;
 }
 public async Task<bool> KullaniciyaAitMiAsync(int talepId,int kullaniciId,CancellationToken ct){await using var c=factory.CreateConnection();await c.OpenAsync(ct);await using var cmd=new SqlCommand("SELECT COUNT(1) FROM dbo.SatinAlmaTalepleri WHERE TalepID=@TalepID AND TalepEdenKullaniciID=@KullaniciID",c);P(cmd,"@TalepID",SqlDbType.Int,talepId);P(cmd,"@KullaniciID",SqlDbType.Int,kullaniciId);return Convert.ToInt32(await cmd.ExecuteScalarAsync(ct))==1;}
 public async Task EkleAsync(int uid,TalepFormModel m,CancellationToken ct){await using var c=factory.CreateConnection();await c.OpenAsync(ct);await using var cmd=Komut(c,"dbo.sp_TalepEkle");P(cmd,"@TalepEdenKullaniciID",SqlDbType.Int,uid);Alanlar(cmd,m,false);await cmd.ExecuteNonQueryAsync(ct);}
 public async Task GuncelleAsync(TalepFormModel m,CancellationToken ct){if(!m.TalepId.HasValue)throw new InvalidOperationException("Talep ID zorunludur.");await using var c=factory.CreateConnection();await c.OpenAsync(ct);await using var cmd=Komut(c,"dbo.sp_TalepDuzenle");P(cmd,"@TalepID",SqlDbType.Int,m.TalepId);Alanlar(cmd,m,true);await cmd.ExecuteNonQueryAsync(ct);}
 public async Task ReddetAsync(string no,CancellationToken ct){await Calistir(no,"dbo.sp_TalebiReddet",ct);}
 public async Task GeriAlAsync(string no,CancellationToken ct){await Calistir(no,"dbo.sp_TalepGeriAl",ct);}
 public async Task InceleAsync(int uid,TalepIncelemeModel m,CancellationToken ct){await using var c=factory.CreateConnection();await c.OpenAsync(ct);await using var cmd=Komut(c,"dbo.sp_TalepIncele");P(cmd,"@TalepID",SqlDbType.Int,m.TalepId);P(cmd,"@MevcutStokMiktari",SqlDbType.Decimal,m.MevcutStokMiktari);cmd.Parameters["@MevcutStokMiktari"].Precision=18;cmd.Parameters["@MevcutStokMiktari"].Scale=2;P(cmd,"@StokYeterlilikSuresiGun",SqlDbType.Int,m.StokYeterlilikSuresiGun);P(cmd,"@ErtelenebilirMi",SqlDbType.Bit,m.ErtelenebilirMi);P(cmd,"@InceleyenKullaniciID",SqlDbType.Int,uid);await cmd.ExecuteNonQueryAsync(ct);}
 private async Task Calistir(string no,string sp,CancellationToken ct){await using var c=factory.CreateConnection();await c.OpenAsync(ct);await using var cmd=Komut(c,sp);P(cmd,"@TalepNo",SqlDbType.NVarChar,no,20);await cmd.ExecuteNonQueryAsync(ct);}
 private static void Alanlar(SqlCommand c,TalepFormModel m,bool duzenle){P(c,"@UrunAdi",SqlDbType.NVarChar,m.UrunAdi,150);P(c,duzenle?"@UrunAciklamasi":"@Aciklama",SqlDbType.NVarChar,m.Aciklama,duzenle?255:500);P(c,"@Miktar",SqlDbType.Decimal,m.Miktar);c.Parameters["@Miktar"].Precision=18;c.Parameters["@Miktar"].Scale=2;P(c,"@Birim",SqlDbType.NVarChar,m.Birim,duzenle?20:30);}
 private static SqlCommand Komut(SqlConnection c,string ad)=>new(ad,c){CommandType=CommandType.StoredProcedure};
 private static void P(SqlCommand c,string ad,SqlDbType tip,object? deger,int? boyut=null){var p=boyut.HasValue?c.Parameters.Add(ad,tip,boyut.Value):c.Parameters.Add(ad,tip);p.Value=deger??DBNull.Value;}
}
