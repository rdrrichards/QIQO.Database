/*****************************************************************
**	Table Name: invoice
**	Procedure Name: usp_invoice_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_invoice_open_by_account]
	@account_key int
AS
SET NOCOUNT ON

SELECT A.[invoice_key], 
	A.[from_entity_key], 
	A.[account_key], 
	A.invoice_num,
	A.[account_contact_key], 
	A.[invoice_entry_date], 
	A.[order_entry_date], 
	A.[invoice_status_key], 
	A.[invoice_status_date], 
	A.[order_ship_date], 
	A.[account_rep_key], 
	A.[sales_rep_key],
	A.[invoice_complete_date], 
	A.[invoice_value_sum], 
	A.[invoice_item_count], 
	A.[audit_add_user_id], 
	A.[audit_add_datetime], 
	A.[audit_update_user_id], 
	A.[audit_update_datetime]
FROM invoice A 
WHERE A.account_key = @account_key
AND A.invoice_status_key NOT IN (4,5)


SET NOCOUNT OFF

