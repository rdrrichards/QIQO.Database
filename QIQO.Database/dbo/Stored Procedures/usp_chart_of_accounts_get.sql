/*****************************************************************
**	Table Name: chart_of_accounts
**	Procedure Name: usp_chart_of_accounts_get
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_chart_of_accounts_get]
	@coa_key int
AS
SET NOCOUNT ON

SELECT [coa_key], 
	[company_key], 
	[acct_no], 
	[acct_name],
	--[department_no], 
	--[lob_no], 
	[balance_type],
	[bank_acct_flg],
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM chart_of_accounts
WHERE [coa_key] = @coa_key


SET NOCOUNT OFF


