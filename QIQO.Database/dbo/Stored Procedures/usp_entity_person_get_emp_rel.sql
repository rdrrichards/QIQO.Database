
/*****************************************************************
**	Table Name: entity_person
**	Procedure Name: usp_entity_person_get_emp_rel
**	Author: Richard Richards
**	Created: 03/11/2016
**	Copyright: QIQO Software, (c) 2016
******************************************************************/

CREATE PROC [dbo].[usp_entity_person_get_emp_rel]
	@person_key int,
	@entity_type_key int -- 12 will give you the manager, 13 will give you a coworker
AS
SET NOCOUNT ON

SELECT TOP 1 -- ideally this should only return 1 row, but I want to be sure 
	[entity_person_key], 
	[person_key], 
	[person_type_key], 
	[person_role], 
	[entity_key], 
	[entity_type_key], 
	[comment], 
	[start_date],
	[end_date],
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM entity_person
WHERE [person_key] = @person_key
AND [entity_type_key] = @entity_type_key
AND GETDATE() BETWEEN [start_date] AND [end_date]

SET NOCOUNT OFF

