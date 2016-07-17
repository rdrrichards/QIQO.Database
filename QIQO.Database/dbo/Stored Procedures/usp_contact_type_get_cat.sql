/*****************************************************************
**	Table Name: contact_type
**	Procedure Name: usp_contact_type_get_cat
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_contact_type_get_cat]
	@contact_type_category int
AS
SET NOCOUNT ON

SELECT [contact_type_key], 
	[contact_type_category], 
	[contact_type_code], 
	[contact_type_name], 
	[contact_type_desc], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM contact_type
WHERE [contact_type_category] = @contact_type_category


SET NOCOUNT OFF
