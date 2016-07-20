/*****************************************************************
**	Table Name: attribute
**	Procedure Name: usp_attribute_get
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_attribute_get]
	@attribute_key int
AS
SET NOCOUNT ON

SELECT [attribute_key], 
	[entity_key], 
	[entity_type_key], 
	[attribute_type_key], 
	[attribute_value], 
	[attribute_data_type_key], 
	[attribute_display_format], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM attribute
WHERE [attribute_key] = @attribute_key


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_attribute_get] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_attribute_get] TO [businessuser]
    AS [dbo];

