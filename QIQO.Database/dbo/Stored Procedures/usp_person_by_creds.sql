/*****************************************************************
**	Table Name: person
**	Procedure Name: usp_person_by_creds
**	Author: Richard Richards
**	Created: 07/21/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_person_by_creds]
	@user_name varchar(30)
AS
SET NOCOUNT ON

SELECT A.[person_key], 
	A.[person_code], 
	A.[person_first_name], 
	A.[person_mi], 
	A.[person_last_name], 
	A.[parent_person_key], 
	A.[person_dob], 
	A.[audit_add_user_id], 
	A.[audit_add_datetime], 
	A.[audit_update_user_id], 
	A.[audit_update_datetime]
FROM person A INNER JOIN attribute B
ON A.person_key = B.entity_key
AND B.entity_type_key = 2
WHERE B.attribute_type_key = 5
AND B.attribute_value = @user_name


SET NOCOUNT OFF
