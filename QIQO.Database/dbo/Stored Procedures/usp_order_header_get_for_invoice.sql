
/*****************************************************************
**	Table Name: order_header
**	Procedure Name: usp_order_header_get_for_invoice 1, 2
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_order_header_get_for_invoice]
	@company_key int,
	@account_key int
	--@test_pattern varchar(50) = ''

AS

SET NOCOUNT ON

SELECT DISTINCT A.[order_key], 
	A.[account_key], 
	A.[order_num],
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
FROM order_header A JOIN account B
ON A.account_key = B.account_key
JOIN company C
ON B.company_key = C.company_key
JOIN order_item D
ON A.order_key = D.order_key
LEFT JOIN invoice_item E
ON D.order_item_key = E.order_item_key
WHERE C.company_key = @company_key
AND A.account_key = @account_key
AND A.[order_status_key] NOT IN (13)
AND E.invoice_item_key IS NULL
--AND ([account_code] LIKE '%' + @test_pattern + '%'
--	OR [account_name] LIKE '%' + @test_pattern + '%'
--	OR [account_desc] LIKE '%' + @test_pattern + '%'
--	OR [account_dba] LIKE '%' + @test_pattern + '%'
--	OR A.[order_num] LIKE '%' + @test_pattern + '%')


SET NOCOUNT OFF




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_order_header_get_for_invoice] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_order_header_get_for_invoice] TO [businessuser]
    AS [dbo];

