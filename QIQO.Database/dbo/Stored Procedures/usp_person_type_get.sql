/*****************************************************************
**	Table Name: person_type
**	Procedure Name: usp_person_type_get
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_person_type_get]
	@person_type_key int
AS
SET NOCOUNT ON

SELECT [person_type_key], 
	[person_type_category], 
	[person_type_code], 
	[person_type_name], 
	[person_type_desc], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM person_type
WHERE [person_type_key] = @person_type_key


SET NOCOUNT OFF


