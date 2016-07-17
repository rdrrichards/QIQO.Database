/*****************************************************************
**	Table Name: comment
**	Procedure Name: usp_comment_get
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_comment_get]
	@comment_key int
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
WHERE [comment_key] = @comment_key


SET NOCOUNT OFF


