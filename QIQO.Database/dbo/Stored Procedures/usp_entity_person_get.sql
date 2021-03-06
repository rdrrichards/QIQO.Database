﻿/*****************************************************************
**	Table Name: entity_person
**	Procedure Name: usp_entity_person_get
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_entity_person_get]
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


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_entity_person_get] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_entity_person_get] TO [businessuser]
    AS [dbo];

