using System.Security.Cryptography;
using System.Text;

namespace PizzaSatinAlmaYonetimi.Web.Services;

public sealed class SifreDogrulamaService(IConfiguration configuration) : ISifreDogrulamaService
{
    public bool Dogrula(string sifre, byte[] salt, byte[] beklenenHash)
    {
        var pepper = configuration["Security:PasswordPepper"];
        if (string.IsNullOrWhiteSpace(pepper) ||
            string.Equals(pepper, "DEVELOPMENT_PLACEHOLDER_PEPPER", StringComparison.Ordinal))
            throw new InvalidOperationException("Şifre pepper değeri güvenli yapılandırmada tanımlanmalıdır.");

        var iterations = configuration.GetValue("Security:Pbkdf2Iterations", 210000);
        if (iterations < 100000)
            throw new InvalidOperationException("PBKDF2 tekrar sayısı güvenli alt sınırın altında olamaz.");

        var passwordBytes = Encoding.UTF8.GetBytes(string.Concat(sifre, pepper));
        var calculatedHash = Rfc2898DeriveBytes.Pbkdf2(passwordBytes, salt, iterations, HashAlgorithmName.SHA512, beklenenHash.Length);
        return CryptographicOperations.FixedTimeEquals(calculatedHash, beklenenHash);
    }
}
