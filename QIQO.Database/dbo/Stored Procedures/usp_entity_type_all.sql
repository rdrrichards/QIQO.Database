/*****************************************************************
**	Table Name: entity_type
**	Procedure Name: usp_entity_type_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_entity_type_all]
AS
SET NOCOUNT ON

SELECT [entity_type_key], 
	[entity_type_code], 
	[entity_type_name], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM entity_type


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_entity_type_all] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_entity_type_all] TO [businessuser]
    AS [dbo];

