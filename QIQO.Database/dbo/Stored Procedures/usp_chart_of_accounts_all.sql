﻿/*****************************************************************
**	Table Name: chart_of_accounts
**	Procedure Name: usp_chart_of_accounts_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_chart_of_accounts_all]
AS
SET NOCOUNT ON

SELECT [coa_key], 
	[company_key], 
	[acct_no], 
	[acct_name],
	[acct_type],
	--[department_no], 
	--[lob_no], 
	[balance_type],
	[bank_acct_flg],
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM chart_of_accounts


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_chart_of_accounts_all] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_chart_of_accounts_all] TO [businessuser]
    AS [dbo];

