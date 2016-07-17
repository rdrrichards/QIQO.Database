/*****************************************************************
**	Table Name: person
**	Procedure Name: usp_person_all_by_company 1
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_person_all_by_company]
@company_key int

AS
SET NOCOUNT ON

SELECT --DISTINCT 
	B.[person_key], 
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
	INNER JOIN entity_type C
	ON A.entity_type_key = C.entity_type_key
	INNER JOIN company D
	ON A.entity_key = D.company_key
	INNER JOIN person_type E
	ON A.person_type_key = E.person_type_key
WHERE D.company_key = @company_key


SET NOCOUNT OFF


