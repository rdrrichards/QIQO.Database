

/*****************************************************************
**	Table Name: vendor
**	Procedure Name: usp_vendor_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_vendor_del]
	@vendor_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	DELETE FROM vendor
	WHERE [vendor_key] = @vendor_key;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'vendor', 'usp_vendor_del';
	THROW;
END CATCH

SET NOCOUNT OFF




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_vendor_del] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_vendor_del] TO [businessuser]
    AS [dbo];

