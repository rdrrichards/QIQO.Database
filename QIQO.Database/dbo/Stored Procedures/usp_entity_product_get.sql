/*****************************************************************
**	Table Name: entity_product
**	Procedure Name: usp_entity_product_get
**	Author: Richard Richards
**	Created: 07/05/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_entity_product_get]
	@entity_product_key int
AS
SET NOCOUNT ON

SELECT [entity_product_key], 
	[product_key], 
	[product_type_key], 
	[entity_product_seq], 
	[entity_key], 
	[entity_type_key], 
	[comment], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM entity_product
WHERE [entity_product_key] = @entity_product_key


SET NOCOUNT OFF


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_entity_product_get] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_entity_product_get] TO [businessuser]
    AS [dbo];

