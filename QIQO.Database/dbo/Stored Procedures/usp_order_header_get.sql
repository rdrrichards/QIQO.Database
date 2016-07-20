/*****************************************************************
**	Table Name: order_header
**	Procedure Name: usp_order_header_get
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_order_header_get]
	@order_key int
AS
SET NOCOUNT ON

SELECT [order_key], 
	[account_key], 
	[account_contact_key], 
	[order_num],
	[order_entry_date], 
	[order_status_key], 
	[order_status_date], 
	[order_ship_date], 
	[account_rep_key], 
	[order_complete_date], 
	[order_value_sum], 
	[order_item_count], 
	[deliver_by_date],
	[sales_rep_key],
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM order_header
WHERE [order_key] = @order_key


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_order_header_get] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_order_header_get] TO [businessuser]
    AS [dbo];

