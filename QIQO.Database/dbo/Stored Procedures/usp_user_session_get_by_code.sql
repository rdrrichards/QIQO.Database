/*****************************************************************
**	Table Name: user_session
**	Procedure Name: usp_user_session_get_by_code
**	Author: Richard Richards
**	Created: 07/26/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_user_session_get_by_code]
	@session_code varchar(50)
AS
SET NOCOUNT ON

SELECT [session_key], 
	[session_code], 
	[host_name], 
	[user_domain], 
	[user_name], 
	[process_id],
	[company_key], 
	[start_date], 
	[end_date], 
	CONVERT(int, [active_flg]) AS [active_flg], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM user_session
WHERE [session_code] = @session_code
AND active_flg = 1

SET NOCOUNT OFF


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_user_session_get_by_code] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_user_session_get_by_code] TO [businessuser]
    AS [dbo];

