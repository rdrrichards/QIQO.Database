/*****************************************************************
**	Table Name: comment
**	Procedure Name: usp_comment_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_comment_all]
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


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_comment_all] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_comment_all] TO [businessuser]
    AS [dbo];

