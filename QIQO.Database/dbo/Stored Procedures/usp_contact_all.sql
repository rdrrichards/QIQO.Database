/*****************************************************************
**	Table Name: contact
**	Procedure Name: usp_contact_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_contact_all]
AS
SET NOCOUNT ON

SELECT [contact_key], 
	[entity_key], 
	[entity_type_key], 
	[contact_type_key], 
	[contact_value], 
	CAST([contact_default_flg] AS int) AS [contact_default_flg], 
	CAST([contact_active_flg] AS int) AS [contact_active_flg], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM contact


SET NOCOUNT OFF


