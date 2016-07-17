

/*****************************************************************
**	Table Name: order_status
**	Procedure Name: usp_order_status_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_order_status_del]
	@order_status_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	DELETE FROM order_status
	WHERE [order_status_key] = @order_status_key;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'order_status', 'usp_order_status_del';
	THROW;
END CATCH

SET NOCOUNT OFF



