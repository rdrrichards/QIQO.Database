
/*****************************************************************
**	Table Name: fee_schedule
**	Procedure Name: usp_fee_schedule_del
**	Author: Richard Richards
**	Created: 07/15/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_fee_schedule_del]
	@fee_schedule_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	DELETE FROM fee_schedule
	WHERE [fee_schedule_key] = @fee_schedule_key;
	
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'fee_schedule', 'usp_fee_schedule_del';
	THROW;
END CATCH

SET NOCOUNT OFF


