/*****************************************************************
**	Table Name: account
**	Procedure Name: usp_account_get_c
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_account_get_c]
	@account_code varchar(10),
	@company_code varchar(10)
AS
SET NOCOUNT ON

SELECT A.[account_key], 
	A.[company_key], 
	A.[account_type_key], 
	A.[account_code], 
	A.[account_name], 
	A.[account_desc], 
	A.[account_dba], 
	A.[account_start_date], 
	A.[account_end_date], 
	A.[audit_add_user_id], 
	A.[audit_add_datetime], 
	A.[audit_update_user_id], 
	A.[audit_update_datetime]
FROM account A INNER JOIN company B
ON A.company_key = B.company_key
WHERE [account_code] = @account_code
AND B.company_code = @company_code


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_account_get_c] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_account_get_c] TO [businessuser]
    AS [dbo];

