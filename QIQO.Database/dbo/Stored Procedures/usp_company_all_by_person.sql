/*****************************************************************
**	Table Name: company
**	Procedure Name: usp_company_get
**	Author: Richard Richards
**	Created: 07/03/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_company_all_by_person]
	@employee_key int
AS
SET NOCOUNT ON

SELECT DISTINCT D.[company_key], 
	D.[company_code], 
	D.[company_name], 
	D.[company_desc], 
	D.[audit_add_user_id], 
	D.[audit_add_datetime], 
	D.[audit_update_user_id], 
	D.[audit_update_datetime]
FROM entity_person A INNER JOIN person B
	ON A.person_key = B.person_key
	INNER JOIN entity_type C
	ON A.entity_type_key = C.entity_type_key
	INNER JOIN company D
	ON A.entity_key = D.company_key
	INNER JOIN person_type E
	ON A.person_type_key = E.person_type_key
WHERE B.person_key = @employee_key


SET NOCOUNT OFF

