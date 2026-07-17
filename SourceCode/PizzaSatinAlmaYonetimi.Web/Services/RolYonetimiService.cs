using System.Data;
using Microsoft.Data.SqlClient;
using PizzaSatinAlmaYonetimi.Web.Data;
using PizzaSatinAlmaYonetimi.Web.Models;
namespace PizzaSatinAlmaYonetimi.Web.Services;

public sealed class RolYonetimiService(ISqlConnectionFactory connectionFactory) : IRolYonetimiService
{
    public async Task<IReadOnlyList<RolListeSatiri>> ListeleAsync(CancellationToken ct){await using var c=connectionFactory.CreateConnection();await c.OpenAsync(ct);await using var cmd=Komut(c,"dbo.sp_RolleriListele");await using var r=await cmd.ExecuteReaderAsync(ct);var list=new List<RolListeSatiri>();while(await r.ReadAsync(ct))list.Add(new(r.GetInt32("RolID"),r.GetString("RolAdi"),r.IsDBNull("Aciklama")?null:r.GetString("Aciklama"),r.GetInt32("KullaniciSayisi")));return list;}
    public async Task<IReadOnlyList<RolYetkisi>> YetkileriGetirAsync(int rolId,CancellationToken ct){await using var c=connectionFactory.CreateConnection();await c.OpenAsync(ct);await using var cmd=Komut(c,"dbo.sp_RolYetkileriniGetir");Ekle(cmd,"@RolID",rolId);await using var r=await cmd.ExecuteReaderAsync(ct);var list=new List<RolYetkisi>();while(await r.ReadAsync(ct))list.Add(new(r.GetInt32("YetkiID"),r.GetString("YetkiKodu"),r.GetString("YetkiAdi"),r.IsDBNull("Aciklama")?null:r.GetString("Aciklama"),r.GetInt32("SeciliMi")==1));return list;}
    public async Task EkleAsync(RolFormModel m,CancellationToken ct){await using var c=connectionFactory.CreateConnection();await c.OpenAsync(ct);await using var cmd=Komut(c,"dbo.sp_RolEkle");Alanlar(cmd,m);await cmd.ExecuteNonQueryAsync(ct);}
    public async Task GuncelleAsync(RolFormModel m,CancellationToken ct){if(!m.RolId.HasValue)throw new InvalidOperationException("Rol ID zorunludur.");await using var c=connectionFactory.CreateConnection();await c.OpenAsync(ct);await using var cmd=Komut(c,"dbo.sp_RolGuncelle");Ekle(cmd,"@RolID",m.RolId.Value);Alanlar(cmd,m);await cmd.ExecuteNonQueryAsync(ct);}
    public async Task YetkileriGuncelleAsync(int rolId,IReadOnlyCollection<int> secilen,CancellationToken ct){await using var c=connectionFactory.CreateConnection();await c.OpenAsync(ct);var mevcut=(await YetkileriGetirAsync(rolId,ct)).Where(x=>x.SeciliMi).Select(x=>x.YetkiId).ToHashSet();await using var tx=await c.BeginTransactionAsync(ct);try{foreach(var id in secilen.Except(mevcut))await Calistir(c,(SqlTransaction)tx,"dbo.sp_RoleYetkiEkle",rolId,id,ct);foreach(var id in mevcut.Except(secilen))await Calistir(c,(SqlTransaction)tx,"dbo.sp_RoldenYetkiKaldir",rolId,id,ct);await tx.CommitAsync(ct);}catch{await tx.RollbackAsync(ct);throw;}}
    private static async Task Calistir(SqlConnection c,SqlTransaction t,string ad,int rolId,int yetkiId,CancellationToken ct){await using var cmd=Komut(c,ad,t);Ekle(cmd,"@RolID",rolId);Ekle(cmd,"@YetkiID",yetkiId);await cmd.ExecuteNonQueryAsync(ct);}
    private static SqlCommand Komut(SqlConnection c,string ad,SqlTransaction? t=null)=>new(ad,c,t){CommandType=CommandType.StoredProcedure};
    private static void Ekle(SqlCommand c,string ad,int deger)=>c.Parameters.Add(ad,SqlDbType.Int).Value=deger;
    private static void Alanlar(SqlCommand c,RolFormModel m){c.Parameters.Add("@RolAdi",SqlDbType.NVarChar,100).Value=m.RolAdi;c.Parameters.Add("@Aciklama",SqlDbType.NVarChar,500).Value=(object?)m.Aciklama??DBNull.Value;}
}
