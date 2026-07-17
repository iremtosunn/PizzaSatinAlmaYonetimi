using Microsoft.Data.SqlClient;

namespace PizzaSatinAlmaYonetimi.Web.Data;

public sealed class SqlConnectionFactory(IConfiguration configuration) : ISqlConnectionFactory
{
    public SqlConnection CreateConnection()
    {
        var connectionString = configuration.GetConnectionString("SqlServer")
            ?? throw new InvalidOperationException("SqlServer bağlantı dizesi tanımlanmamış.");

        return new SqlConnection(connectionString);
    }
}
