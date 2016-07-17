/*****************************************************************
**	Table Name: product
**	Procedure Name: usp_product_get
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_product_get]
	@product_key int
AS
SET NOCOUNT ON

SELECT [product_key], 
	[product_type_key], 
	[product_code], 
	[product_name], 
	[product_desc], 
	[product_name_short], 
	[product_name_long], 
	[product_image_path], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM product
WHERE [product_key] = @product_key


SET NOCOUNT OFF


