
/*****************************************************************
**	Table Name: comment
**	Procedure Name: usp_comment_all_by_entity
**	Author: Richard Richards
**	Created: 03/15/2016
**	Copyright: QIQO Software, (c) 2016
******************************************************************/

CREATE PROC [dbo].[usp_comment_all_by_entity]
	@entity_key int,
	@entity_type_key int
AS
SET NOCOUNT ON

SELECT [comment_key], 
	[entity_key], 
	[entity_type], 
	[comment_type_key], 
	[comment_value], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM comment
WHERE entity_key = @entity_key
AND entity_type = @entity_type_key

SET NOCOUNT OFF




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_comment_all_by_entity] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_comment_all_by_entity] TO [businessuser]
    AS [dbo];

