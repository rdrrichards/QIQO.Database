




/*****************************************************************
**	Table Name: ledger_txn
**	Procedure Name: usp_ledger_txn_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_ledger_txn_ups]

	@ledger_txn_key int,
	@ledger_key int,
	@txn_comment varchar(50),
	@acct_from varchar(10),
	@dept_from varchar(10),
	@lob_from varchar(10),
	@acct_to varchar(10),
	@dept_to varchar(10),
	@lob_to varchar(10),
	@txn_num int,
	@post_date datetime,
	@entry_date datetime,
	@credit money,
	@debit money,
	@entity_key int,
	@entity_type_key int,
	@key int out
AS
SET NOCOUNT ON
IF @ledger_txn_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR ledger_txn_key_seq;
	INSERT INTO ledger_txn ([ledger_txn_key],
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
		[debit]
		,entity_key
		,entity_type_key
	)
	VALUES (@new_key,
		@ledger_key,
		@txn_comment,
		@acct_from,
		@dept_from,
		@lob_from,
		@acct_to,
		@dept_to,
		@lob_to,
		@txn_num,
		@post_date,
		@entry_date,
		@credit,
		@debit,
		@entity_key,
		@entity_type_key
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'ledger_txn', 'usp_ledger_txn_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE ledger_txn SET 
		[ledger_key] = @ledger_key,
		txn_comment = @txn_comment,
		[acct_from] = @acct_from,
		[dept_from] = @dept_from,
		[lob_from] = @lob_from,
		[acct_to] = @acct_to,
		[dept_to] = @dept_to,
		[lob_to] = @lob_to,
		[txn_num] = @txn_num,
		[post_date] = @post_date,
		[entry_date] = @entry_date,
		[credit] = @credit,
		[debit] = @debit,
		entity_key = @entity_key,
		entity_type_key = @entity_type_key
	WHERE [ledger_txn_key] = @ledger_txn_key;
	SELECT @key = @ledger_txn_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'ledger_txn', 'usp_ledger_txn_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF








GO
GRANT EXECUTE
	ON OBJECT::[dbo].[usp_ledger_txn_ups] TO [RDRRL8\QIQOServiceAccount]
	AS [dbo];


GO
GRANT EXECUTE
	ON OBJECT::[dbo].[usp_ledger_txn_ups] TO [businessuser]
	AS [dbo];

