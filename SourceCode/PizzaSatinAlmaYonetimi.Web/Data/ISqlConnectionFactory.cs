using Microsoft.Data.SqlClient;

namespace PizzaSatinAlmaYonetimi.Web.Data;

public interface ISqlConnectionFactory
{
    SqlConnection CreateConnection();
}
