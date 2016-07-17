/*****************************************************************
**	Table Name: audit_log
**	Procedure Name: usp_audit_log_all
**	Author: Richard Richards
**	Created: 07/05/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_audit_log_all_bus_obj]
	@bus_obj varchar(30)
AS
SET NOCOUNT ON

SELECT [audit_log_key], 
	[audit_action], 
	[audit_bus_obj], 
	[audit_datetime], 
	[audit_user_id], 
	[audit_app_name], 
	[audit_host_name], 
	ISNULL([audit_comment], '') AS [audit_comment], 
	ISNULL([audit_data_old], '') AS [audit_data_old], 
	ISNULL([audit_data_new], '') AS [audit_data_new],  
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM audit_log
WHERE audit_bus_obj = @bus_obj

SET NOCOUNT OFF


