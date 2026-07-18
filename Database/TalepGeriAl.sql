USE [PizzaSatinAlmaDB];
GO

CREATE OR ALTER PROCEDURE dbo.sp_TalepGeriAl
    @TalepNo nvarchar(20)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    UPDATE dbo.SatinAlmaTalepleri
    SET TalepDurumID = 0
    WHERE TalepNo = @TalepNo
      AND TalepDurumID = 3;

    IF @@ROWCOUNT = 0
        THROW 50015, N'Yalnızca reddedilmiş bir talep geri alınabilir.', 1;
END;
GO
