/*****************************************************************
**	Table Name: invoice_item
**	Procedure Name: usp_invoice_item_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_invoice_item_all]
	@invoice_key int
AS
SET NOCOUNT ON

SELECT [invoice_item_key], 
	[invoice_key], 
	[invoice_item_seq],
	[product_key], 
	[product_name],
	[product_desc],
	[invoice_item_quantity], 
	[shipto_addr_key], 
	[billto_addr_key], 
	[invoice_item_entry_date], 
	[order_item_ship_date], 
	[invoice_item_complete_date], 
	[invoice_item_price_per], 
	[invoice_item_line_sum], 
	[invoice_item_account_rep_key], 
	[invoice_item_sales_rep_key],
	[invoice_item_status_key], 
	[order_item_key], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM invoice_item
WHERE invoice_key = @invoice_key


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_item_all] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_item_all] TO [businessuser]
    AS [dbo];

