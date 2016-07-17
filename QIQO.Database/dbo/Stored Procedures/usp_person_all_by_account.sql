/*****************************************************************
**	Table Name: entity_person
**	Procedure Name: usp_entity_person_get_by_rel
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_person_all_by_account]
	@account_key int
AS
SET NOCOUNT ON

SELECT B.[person_key], 
	B.[person_code], 
	B.[person_first_name], 
	B.[person_mi], 
	B.[person_last_name], 
	B.[parent_person_key], 
	B.[person_dob], 
	B.[audit_add_user_id], 
	B.[audit_add_datetime], 
	B.[audit_update_user_id], 
	B.[audit_update_datetime]
FROM entity_person A INNER JOIN person B
ON A.person_key = B.person_key
AND A.person_type_key = 6
INNER JOIN account C
ON A.entity_key = C.account_key
AND A.entity_type_key = 3
INNER JOIN person_type E
ON A.person_type_key = E.person_type_key
WHERE C.account_key = @account_key

SET NOCOUNT OFF

