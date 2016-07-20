/*****************************************************************
**	Table Name: account
**	Procedure Name: usp_account_all_by_company
**	Author: Richard Richards
**	Created: 07/05/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_account_all_by_company]
	@company_key int
AS
SET NOCOUNT ON

SELECT [account_key], 
	[company_key], 
	[account_type_key], 
	[account_code], 
	[account_name], 
	[account_desc], 
	[account_dba], 
	[account_start_date], 
	[account_end_date], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM account
WHERE company_key = @company_key


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_account_all_by_company] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_account_all_by_company] TO [businessuser]
    AS [dbo];

