/*****************************************************************
**	Table Name: attribute
**	Procedure Name: usp_attribute_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_attribute_all_by_entity]
	@entity_key int,
	@entity_type_key int
AS
SET NOCOUNT ON

CREATE TABLE #att_cats (attribute_type_category varchar(50))

IF @entity_type_key = 1 -- company
	INSERT INTO #att_cats VALUES ('Company'),('Company Contact')
IF @entity_type_key = 3 -- account
	INSERT INTO #att_cats VALUES ('Account'),('Account Contact'),('General Contact')
IF @entity_type_key = 2 -- person / employee
	INSERT INTO #att_cats VALUES ('Employee'),('General Contact')
IF @entity_type_key = 4 -- products
	INSERT INTO #att_cats VALUES ('Product')

SELECT ISNULL(A.[attribute_key], 0) AS attribute_key, 
	ISNULL(A.[entity_key], @entity_key) AS entity_key, 
	ISNULL(A.[entity_type_key], @entity_type_key) AS entity_type_key,
	B.[attribute_type_key], 
	ISNULL(A.[attribute_value],'') AS attribute_value, 
	B.[attribute_data_type_key], 
	ISNULL(NULLIF(A.[attribute_display_format], ''), B.attribute_default_format) AS attribute_display_format, 
	ISNULL(A.[audit_add_user_id], SUSER_NAME()) AS audit_add_user_id, 
	ISNULL(A.[audit_add_datetime], GETDATE()) AS audit_add_datetime, 
	ISNULL(A.[audit_update_user_id], SUSER_NAME()) AS audit_update_user_id, 
	ISNULL(A.[audit_update_datetime], GETDATE()) AS audit_update_datetime --, B.*
FROM attribute_type B LEFT JOIN attribute A 
ON A.attribute_type_key = B.attribute_type_key
AND A.entity_key = @entity_key
AND A.entity_type_key = @entity_type_key
WHERE B.attribute_type_category IN (SELECT attribute_type_category FROM #att_cats)

DROP TABLE #att_cats

/*
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
FROM attribute A
WHERE A.entity_key = @entity_key
AND A.entity_type_key = @entity_type_key
*/

SET NOCOUNT OFF




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_attribute_all_by_entity] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_attribute_all_by_entity] TO [businessuser]
    AS [dbo];

