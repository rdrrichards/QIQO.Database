

/*****************************************************************
**	Table Name: invoice
**	Procedure Name: usp_invoice_get_c
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_invoice_get_c]
	@company_code varchar(10),
	@invoice_code varchar(20)
AS
SET NOCOUNT ON

SELECT [invoice_key], 
	[from_entity_key], 
	A.[account_key], 
	[account_contact_key], 
	[invoice_num],
	[invoice_entry_date], 
	[order_entry_date], 
	[invoice_status_key], 
	[invoice_status_date], 
	[order_ship_date], 
	[account_rep_key], 
	A.[sales_rep_key],
	[invoice_complete_date], 
	[invoice_value_sum], 
	[invoice_item_count], 
	A.[audit_add_user_id], 
	A.[audit_add_datetime], 
	A.[audit_update_user_id], 
	A.[audit_update_datetime]
FROM invoice A JOIN account B
ON A.account_key = B.account_key
JOIN company C
ON B.company_key = C.company_key
WHERE C.company_code = @company_code
AND [invoice_num] = @invoice_code


SET NOCOUNT OFF





GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_get_c] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_get_c] TO [businessuser]
    AS [dbo];

