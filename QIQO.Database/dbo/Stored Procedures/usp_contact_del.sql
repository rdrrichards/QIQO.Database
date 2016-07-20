

/*****************************************************************
**	Table Name: contact
**	Procedure Name: usp_contact_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_contact_del]
	@contact_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	DELETE FROM contact
	WHERE [contact_key] = @contact_key;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'contact', 'usp_contact_del';
	THROW;
END CATCH

SET NOCOUNT OFF




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_contact_del] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_contact_del] TO [businessuser]
    AS [dbo];

