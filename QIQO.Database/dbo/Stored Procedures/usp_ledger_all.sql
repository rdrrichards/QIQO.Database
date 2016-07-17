
/*****************************************************************
**	Table Name: ledger
**	Procedure Name: usp_ledger_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_ledger_all]
	@company_key int
AS
SET NOCOUNT ON

SELECT [ledger_key], 
	[company_key], 
	--[coa_key], 
	[ledger_code], 
	[ledger_name], 
	[ledger_desc], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM ledger
WHERE company_key = @company_key


SET NOCOUNT OFF



