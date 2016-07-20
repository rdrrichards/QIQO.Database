

/*****************************************************************
**	Table Name: address_type
**	Procedure Name: usp_address_type_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_address_type_del]
	@address_type_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	DELETE FROM address_type
	WHERE [address_type_key] = @address_type_key;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'address_type', 'usp_address_type_del';
	THROW;
END CATCH

SET NOCOUNT OFF




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_address_type_del] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_address_type_del] TO [businessuser]
    AS [dbo];

