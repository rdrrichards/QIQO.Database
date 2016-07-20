/*****************************************************************
**	Table Name: entity_person
**	Procedure Name: usp_entity_person_by_account 2
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_entity_person_by_account]
	@account_key int
AS
SET NOCOUNT ON

SELECT A.[entity_person_key], 
	A.[person_key], 
	A.[person_type_key], 
	A.[person_role], 
	A.[entity_key], 
	A.[entity_type_key], 
	A.[comment], 
	A.[start_date],
	A.[end_date],
	A.[audit_add_user_id], 
	A.[audit_add_datetime], 
	A.[audit_update_user_id], 
	A.[audit_update_datetime]
FROM entity_person A INNER JOIN person B
	ON A.person_key = B.person_key
	INNER JOIN entity_type C
	ON A.entity_type_key = C.entity_type_key
	INNER JOIN account D
	ON A.entity_key = D.account_key
	INNER JOIN person_type E
	ON A.person_type_key = E.person_type_key
WHERE D.account_key = @account_key
AND A.entity_type_key = 3
AND GETDATE() BETWEEN A.[start_date] AND A.[end_date]

SET NOCOUNT OFF


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_entity_person_by_account] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_entity_person_by_account] TO [businessuser]
    AS [dbo];

