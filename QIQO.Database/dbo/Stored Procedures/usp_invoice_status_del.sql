

/*****************************************************************
**	Table Name: invoice_status
**	Procedure Name: usp_invoice_status_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_invoice_status_del]
	@invoice_status_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	DELETE FROM invoice_status
	WHERE [invoice_status_key] = @invoice_status_key;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'invoice_status', 'usp_invoice_status_del';
	THROW;
END CATCH

SET NOCOUNT OFF



