

/*****************************************************************
**	Table Name: audit_log
**	Procedure Name: usp_audit_log_del
**	Author: Richard Richards
**	Created: 07/05/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_audit_log_del]
	@audit_log_key bigint,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	DELETE FROM audit_log
	WHERE [audit_log_key] = -2 --@audit_log_key
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'audit_log', 'usp_audit_log_del';
	THROW;
END CATCH

SET NOCOUNT OFF



