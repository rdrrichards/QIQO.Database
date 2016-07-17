

/*****************************************************************
**	Table Name: comment
**	Procedure Name: usp_comment_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_comment_del]
	@comment_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	DELETE FROM comment
	WHERE [comment_key] = @comment_key;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'comment', 'usp_comment_del';
	THROW;
END CATCH

SET NOCOUNT OFF



