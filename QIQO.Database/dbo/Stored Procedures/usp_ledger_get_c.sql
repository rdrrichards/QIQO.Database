
/*****************************************************************
**	Table Name: ledger
**	Procedure Name: usp_ledger_get
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_ledger_get_c]
	@ledger_code varchar(10)
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
WHERE [ledger_code] = @ledger_code


SET NOCOUNT OFF



