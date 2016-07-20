/*****************************************************************
**	Table Name: chart_of_accounts
**	Procedure Name: usp_chart_of_accounts_all_by_company
**	Author: Richard Richards
**	Created: 07/14/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_chart_of_accounts_all_by_company_code]
	@company_code varchar(10)
AS
SET NOCOUNT ON

SELECT A.[coa_key], 
	A.[company_key], 
	A.[acct_no], 
	A.[acct_name],
	A.[acct_type],
	--A.[department_no], 
	--A.[lob_no], 
	A.[balance_type],
	A.[bank_acct_flg],
	A.[audit_add_user_id], 
	A.[audit_add_datetime], 
	A.[audit_update_user_id], 
	A.[audit_update_datetime]
FROM chart_of_accounts A INNER JOIN company B
ON A.company_key = B.company_key
WHERE B.company_code = @company_code


SET NOCOUNT OFF


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_chart_of_accounts_all_by_company_code] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_chart_of_accounts_all_by_company_code] TO [businessuser]
    AS [dbo];

