/*****************************************************************
**	Table Name: entity_type
**	Procedure Name: usp_entity_type_get
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_entity_type_get]
	@entity_type_key int
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
WHERE [entity_type_key] = @entity_type_key


SET NOCOUNT OFF


