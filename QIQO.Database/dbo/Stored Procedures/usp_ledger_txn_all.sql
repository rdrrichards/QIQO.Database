
/*****************************************************************
**	Table Name: ledger_txn
**	Procedure Name: usp_ledger_txn_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_ledger_txn_all]
	@ledger_key int
AS
SET NOCOUNT ON

SELECT [ledger_txn_key], 
	[ledger_key], 
	txn_comment,
	[acct_from], 
	[dept_from], 
	[lob_from], 
	[acct_to], 
	[dept_to], 
	[lob_to], 
	[txn_num], 
	[post_date], 
	[entry_date], 
	[credit], 
	[debit], 
	A.entity_key,
	A.entity_type_key,
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM ledger_txn A
WHERE A.ledger_key = @ledger_key


SET NOCOUNT OFF




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_ledger_txn_all] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_ledger_txn_all] TO [businessuser]
    AS [dbo];

