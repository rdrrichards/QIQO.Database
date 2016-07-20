/*****************************************************************
**	Table Name: comment_type
**	Procedure Name: usp_comment_type_get
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_comment_type_get]
	@comment_type_key int
AS
SET NOCOUNT ON

SELECT [comment_type_key], 
	[comment_type_category], 
	[comment_type_code], 
	[comment_type_name], 
	[comment_type_desc], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM comment_type
WHERE [comment_type_key] = @comment_type_key


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_comment_type_get] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_comment_type_get] TO [businessuser]
    AS [dbo];

