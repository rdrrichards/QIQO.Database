
/*****************************************************************
**	Table Name: ledger
**	Procedure Name: usp_ledger_get
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_ledger_get]
	@ledger_key int
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
WHERE [ledger_key] = @ledger_key


SET NOCOUNT OFF




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_ledger_get] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_ledger_get] TO [businessuser]
    AS [dbo];

