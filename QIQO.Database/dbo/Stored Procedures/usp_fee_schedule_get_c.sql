
/*****************************************************************
**	Table Name: fee_schedule
**	Procedure Name: usp_fee_schedule_get
**	Author: Richard Richards
**	Created: 07/15/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_fee_schedule_get_c]
	@product_code varchar(10),
	@account_code varchar(10)
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
	A.[audit_update_datetime]
FROM fee_schedule A INNER JOIN product B
ON A.product_key = B.product_key
INNER JOIN account C
ON A.account_key = C.account_key
WHERE B.product_code = @product_code
AND C.account_code = @account_code


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_fee_schedule_get_c] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_fee_schedule_get_c] TO [businessuser]
    AS [dbo];

