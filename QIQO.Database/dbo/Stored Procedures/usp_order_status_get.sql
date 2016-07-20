/*****************************************************************
**	Table Name: order_status
**	Procedure Name: usp_order_status_get
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_order_status_get]
	@order_status_key int
AS
SET NOCOUNT ON

SELECT [order_status_key], 
	[order_status_code], 
	[order_status_name], 
	[order_status_type], 
	[order_status_desc], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM order_status
WHERE [order_status_key] = @order_status_key


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_order_status_get] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_order_status_get] TO [businessuser]
    AS [dbo];

