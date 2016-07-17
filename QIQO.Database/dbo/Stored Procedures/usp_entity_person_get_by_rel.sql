/*****************************************************************
**	Table Name: entity_person
**	Procedure Name: usp_entity_person_get_by_rel
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_entity_person_get_by_rel]
	@entity_person_key int
AS
SET NOCOUNT ON

SELECT [entity_person_key], 
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
WHERE [entity_person_key] = @entity_person_key
-- AND [entity_key] = @entity_key

SET NOCOUNT OFF
