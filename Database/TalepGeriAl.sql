USE [PizzaSatinAlmaDB];
GO

CREATE OR ALTER PROCEDURE dbo.sp_TalepGeriAl
    @TalepNo nvarchar(20)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.SatinAlmaTalepleri WITH (UPDLOCK, HOLDLOCK)
            WHERE TalepNo = @TalepNo
              AND TalepDurumID = 3
        )
            THROW 50015, N'Yalnızca reddedilmiş bir talep geri alınabilir.', 1;

        UPDATE dbo.SatinAlmaTalepleri
        SET TalepDurumID = 0
        WHERE TalepNo = @TalepNo
          AND TalepDurumID = 3;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
