

/*****************************************************************
**	Table Name: invoice_item
**	Procedure Name: usp_invoice_item_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_invoice_item_del]
	@invoice_item_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	--DELETE FROM invoice_item WHERE [invoice_item_key] = @invoice_item_key;
	UPDATE invoice_item SET invoice_item_status_key = 10,  -- Cancels invoice item versus delete
		invoice_item_complete_date = GETDATE()
	WHERE [invoice_item_key] = @invoice_item_key;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'invoice_item', 'usp_invoice_item_del';
	THROW;
END CATCH

SET NOCOUNT OFF




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_item_del] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_item_del] TO [businessuser]
    AS [dbo];

