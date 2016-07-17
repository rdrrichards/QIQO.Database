/*****************************************************************
**	Table Name: account_type
**	Procedure Name: usp_account_type_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_account_type_all]
AS
SET NOCOUNT ON

SELECT [account_type_key], 
	[account_type_code], 
	[account_type_name], 
	[account_type_desc], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM account_type


SET NOCOUNT OFF


