

/*****************************************************************
**	Table Name: invoice
**	Procedure Name: usp_invoice_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_invoice_del]
	@invoice_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	--DELETE FROM invoice WHERE [invoice_key] = @invoice_key;
	UPDATE invoice SET invoice_status_key = 5, -- Cancels invoice versus delete
		invoice_status_date = GETDATE()
	WHERE [invoice_key] = @invoice_key;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'invoice', 'usp_invoice_del';
	THROW;
END CATCH

SET NOCOUNT OFF




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_del] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_del] TO [businessuser]
    AS [dbo];

