/*****************************************************************
**	Table Name: user_session
**	Procedure Name: usp_user_session_ups
**	Author: Richard Richards
**	Created: 07/26/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_user_session_ups]
	@session_code varchar(50),
	@host_name varchar(50),
	@user_domain varchar(75),
	@user_name varchar(30),
	@process_id int,
	@company_key int,
	@start_date datetime = NULL,
	@end_date datetime = NULL,
	@active_flg bit = 1,
	@key int out
AS
SET NOCOUNT ON
IF NOT EXISTS (SELECT * FROM user_session
	WHERE session_code = @session_code
	AND active_flg = 1) 
BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR user_session_key_seq;
	INSERT INTO user_session ([session_key],
		[session_code],
		[host_name],
		[user_domain],
		[user_name],
		[process_id],
		[company_key],
		[start_date],
		[end_date],
		[active_flg]
	)
	VALUES (@new_key,
		@session_code,
		@host_name,
		@user_domain,
		@user_name,
		@process_id,
		@company_key,
		@start_date,
		@end_date,
		@active_flg
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'user_session', 'usp_user_session_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE user_session SET 
		--[host_name] = @host_name,
		--[user_domain] = @user_domain,
		--[user_name] = @user_name,
		[company_key] = @company_key
		--[start_date] = @start_date,
		--[end_date] = @end_date,
		--[active_flg] = @active_flg
	WHERE [session_code] = @session_code
	AND active_flg = 1
	AND [company_key] <> @company_key;

	SELECT @key = session_key
	FROM user_session
	WHERE [session_code] = @session_code
	AND active_flg = 1
	AND [company_key] = @company_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'user_session', 'usp_user_session_ups', 'U';
		THROW;
	END CATCH
END


SET NOCOUNT OFF


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_user_session_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_user_session_ups] TO [businessuser]
    AS [dbo];

