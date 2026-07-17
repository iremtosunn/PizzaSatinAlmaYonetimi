namespace PizzaSatinAlmaYonetimi.Web.Models;

public sealed record GirisKullanicisi(
    int KullaniciId,
    int RolId,
    string RolAdi,
    string AdSoyad,
    string KullaniciAdi,
    byte[] SifreHash,
    byte[] SifreSalt,
    int Durum);

public sealed record OturumKullanicisi(int KullaniciId, string AdSoyad, string RolAdi);
