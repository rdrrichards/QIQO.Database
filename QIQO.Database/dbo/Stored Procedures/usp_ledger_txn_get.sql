
/*****************************************************************
**	Table Name: ledger_txn
**	Procedure Name: usp_ledger_txn_get
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_ledger_txn_get]
	@ledger_txn_key int
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
	entity_key,
	entity_type_key,
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM ledger_txn
WHERE [ledger_txn_key] = @ledger_txn_key


SET NOCOUNT OFF



