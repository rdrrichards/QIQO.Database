/*****************************************************************
**	Table Name: attribute
**	Procedure Name: usp_attribute_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_attribute_all]
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


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_attribute_all] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_attribute_all] TO [businessuser]
    AS [dbo];

