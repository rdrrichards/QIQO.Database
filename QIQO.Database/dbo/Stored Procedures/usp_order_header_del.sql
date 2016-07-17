

/*****************************************************************
**	Table Name: order_header
**	Procedure Name: usp_order_header_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_order_header_del]
	@order_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	--DELETE FROM order_header WHERE [order_key] = @order_key;
	UPDATE order_header SET order_status_key = 13, -- cancel order, don't delete
		order_status_date = GETDATE()
	WHERE [order_key] = @order_key;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'order_header', 'usp_order_header_del';
	THROW;
END CATCH

SET NOCOUNT OFF



