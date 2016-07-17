

/*****************************************************************
**	Table Name: fee_schedule
**	Procedure Name: usp_fee_schedule_all_by_product 25
**	Author: Richard Richards
**	Created: 07/15/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_fee_schedule_all_by_product]
	@product_key int
AS
SET NOCOUNT ON

SELECT A.[fee_schedule_key], 
	A.[company_key], 
	A.[account_key], 
	A.[product_key], 
	A.[fee_schedule_start_date], 
	A.[fee_schedule_end_date], 
	A.[fee_schedule_type], 
	A.[fee_schedule_value], 
	A.[audit_add_user_id], 
	A.[audit_add_datetime], 
	A.[audit_update_user_id], 
	A.[audit_update_datetime],
	B.product_desc,
	B.product_code
FROM fee_schedule A INNER JOIN product B
ON A.product_key = B.product_key
WHERE A.product_key = @product_key


SET NOCOUNT OFF



