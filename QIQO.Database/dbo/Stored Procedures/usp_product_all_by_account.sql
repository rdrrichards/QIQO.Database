﻿/*****************************************************************
**	Table Name: product
**	Procedure Name: usp_product_all_by_account
**	Author: Richard Richards
**	Created: 07/05/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_product_all_by_account]
	@account_key int
AS
SET NOCOUNT ON

SELECT A.[product_key], 
	A.[product_type_key], 
	A.[product_code], 
	A.[product_name], 
	A.[product_desc], 
	A.[product_name_short], 
	A.[product_name_long], 
	A.[product_image_path], 
	A.[audit_add_user_id], 
	A.[audit_add_datetime], 
	A.[audit_update_user_id], 
	A.[audit_update_datetime]
FROM product A INNER JOIN entity_product B
ON A.product_key = B.product_key
AND B.entity_key = @account_key
AND B.entity_type_key = 3 --account


SET NOCOUNT OFF

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_product_all_by_account] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_product_all_by_account] TO [businessuser]
    AS [dbo];

