
/*****************************************************************
**	Table Name: invoice
**	Procedure Name: usp_invoice_find
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_invoice_find]
	@company_key int,
	@test_pattern varchar(50)

AS
SET NOCOUNT ON

SELECT A.[invoice_key], 
	A.[from_entity_key], 
	A.[account_key], 
	A.[account_contact_key], 
	A.[invoice_num],
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
FROM invoice A JOIN account B
ON A.account_key = B.account_key
JOIN company C
ON B.company_key = C.company_key
WHERE C.company_key = @company_key
AND ([account_code] LIKE '%' + @test_pattern + '%'
	OR [account_name] LIKE '%' + @test_pattern + '%'
	OR [account_desc] LIKE '%' + @test_pattern + '%'
	OR [account_dba] LIKE '%' + @test_pattern + '%'
	OR A.[invoice_num] LIKE '%' + @test_pattern + '%')


SET NOCOUNT OFF



