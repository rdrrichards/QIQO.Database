
/*****************************************************************
**	Table Name: ledger_txn
**	Procedure Name: usp_ledger_txn_all_c]
**	Author: Richard Richards
**	Created: 07/14/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_ledger_txn_all_c]
	@ledger_code varchar(10)
AS
SET NOCOUNT ON

SELECT A.[ledger_txn_key], 
	A.[ledger_key], 
	A.txn_comment,
	A.[acct_from], 
	A.[dept_from], 
	A.[lob_from], 
	A.[acct_to], 
	A.[dept_to], 
	A.[lob_to], 
	A.[txn_num], 
	A.[post_date], 
	A.[entry_date], 
	A.[credit], 
	A.[debit], 
	A.entity_key,
	A.entity_type_key,
	A.[audit_add_user_id], 
	A.[audit_add_datetime], 
	A.[audit_update_user_id], 
	A.[audit_update_datetime]
FROM ledger_txn A INNER JOIN ledger B
ON A.ledger_key = B.ledger_key
WHERE B.ledger_code = @ledger_code


SET NOCOUNT OFF




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_ledger_txn_all_c] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_ledger_txn_all_c] TO [businessuser]
    AS [dbo];

