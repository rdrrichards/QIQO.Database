/*****************************************************************
**	Table Name: person
**	Procedure Name: usp_person_get
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_person_get]
	@person_key int
AS
SET NOCOUNT ON

SELECT [person_key], 
	[person_code], 
	[person_first_name], 
	[person_mi], 
	[person_last_name], 
	[parent_person_key], 
	[person_dob], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM person
WHERE [person_key] = @person_key


SET NOCOUNT OFF


