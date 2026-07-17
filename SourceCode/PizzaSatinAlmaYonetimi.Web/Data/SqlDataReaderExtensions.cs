using Microsoft.Data.SqlClient;

namespace PizzaSatinAlmaYonetimi.Web.Data;

internal static class SqlDataReaderExtensions
{
    public static int GetInt32(this SqlDataReader reader, string name) => reader.GetInt32(reader.GetOrdinal(name));
    public static string GetString(this SqlDataReader reader, string name) => reader.GetString(reader.GetOrdinal(name));
    public static DateTime GetDateTime(this SqlDataReader reader, string name) => reader.GetDateTime(reader.GetOrdinal(name));
    public static bool IsDBNull(this SqlDataReader reader, string name) => reader.IsDBNull(reader.GetOrdinal(name));
}
