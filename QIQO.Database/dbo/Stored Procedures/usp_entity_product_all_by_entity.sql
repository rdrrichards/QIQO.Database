/*****************************************************************
**	Table Name: entity_product
**	Procedure Name: usp_entity_product_all
**	Author: Richard Richards
**	Created: 07/05/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_entity_product_all_by_entity]
	@entity_key int,
	@entity_type_key int

AS
SET NOCOUNT ON

SELECT A.[entity_product_key], 
	A.[product_key], 
	A.[product_type_key], 
	A.[entity_product_seq], 
	A.[entity_key], 
	A.[entity_type_key], 
	A.[comment], 
	A.[audit_add_user_id], 
	A.[audit_add_datetime], 
	A.[audit_update_user_id], 
	A.[audit_update_datetime]
FROM entity_product A INNER JOIN product B
ON A.product_key = B.product_key
AND A.entity_key = @entity_key
AND A.entity_type_key = @entity_type_key


SET NOCOUNT OFF

