﻿/*****************************************************************
**	Table Name: user_session
**	Procedure Name: usp_user_session_del
**	Author: Richard Richards
**	Created: 07/26/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_user_session_del]
	@session_code varchar(50),
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	UPDATE user_session SET 
	WHERE session_code = @session_code;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'user_session', 'usp_user_session_del';
	THROW;
END CATCH

SET NOCOUNT OFF