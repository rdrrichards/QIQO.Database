/*****************************************************************
**	Table Name: invoice
**	Procedure Name: usp_invoice_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_invoice_all]
AS
SET NOCOUNT ON

SELECT [invoice_key], 
	[from_entity_key], 
	[account_key], 
	[invoice_num],
	[account_contact_key], 
	[invoice_entry_date], 
	[order_entry_date], 
	[invoice_status_key], 
	[invoice_status_date], 
	[order_ship_date], 
	[account_rep_key], 
	[sales_rep_key],
	[invoice_complete_date], 
	[invoice_value_sum], 
	[invoice_item_count], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM invoice


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_all] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_all] TO [businessuser]
    AS [dbo];

