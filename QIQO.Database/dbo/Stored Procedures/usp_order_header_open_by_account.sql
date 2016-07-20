/*****************************************************************
**	Table Name: order_header
**	Procedure Name: usp_order_header_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_order_header_open_by_account]
	@account_key int
AS
SET NOCOUNT ON

SELECT A.[order_key], 
	A.[account_key], 
	A.order_num,
	A.[account_contact_key], 
	A.[order_entry_date], 
	A.[order_status_key], 
	A.[order_status_date], 
	A.[order_ship_date], 
	A.[account_rep_key], 
	A.[order_complete_date], 
	A.[order_value_sum], 
	A.[order_item_count], 
	A.[deliver_by_date],
	A.[sales_rep_key],
	A.[audit_add_user_id], 
	A.[audit_add_datetime], 
	A.[audit_update_user_id], 
	A.[audit_update_datetime]
FROM order_header A
WHERE A.account_key = @account_key
AND A.[order_status_key] NOT IN (6,12,13,14)


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_order_header_open_by_account] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_order_header_open_by_account] TO [businessuser]
    AS [dbo];

