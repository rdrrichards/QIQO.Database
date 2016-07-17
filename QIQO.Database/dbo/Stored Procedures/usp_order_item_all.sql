/*****************************************************************
**	Table Name: order_item
**	Procedure Name: usp_order_item_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_order_item_all]
	@order_key int
AS
SET NOCOUNT ON

SELECT [order_item_key], 
	[order_key], 
	[order_item_seq],
	[product_key], 
	[product_name], 
	[product_desc], 
	[order_item_quantity], 
	[shipto_addr_key], 
	[billto_addr_key], 
	[order_item_ship_date], 
	[order_item_complete_date], 
	[order_item_price_per], 
	[order_item_line_sum], 
	[order_item_acct_rep_key], 
	[order_item_sales_rep_key], 
	[order_item_status_key], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM order_item
WHERE order_key = @order_key
ORDER BY 2, 3

SET NOCOUNT OFF


