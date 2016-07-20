

/*****************************************************************
**	Table Name: order_item
**	Procedure Name: usp_order_item_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_order_item_del]
	@order_item_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	--DELETE FROM order_item WHERE [order_item_key] = @order_item_key;
	UPDATE order_item SET order_item_status_key = 14, -- cancel order item, don't delete
		order_item_complete_date = GETDATE()
	WHERE [order_item_key] = @order_item_key;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'order_item', 'usp_order_item_del';
	THROW;
END CATCH

SET NOCOUNT OFF




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_order_item_del] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_order_item_del] TO [businessuser]
    AS [dbo];

