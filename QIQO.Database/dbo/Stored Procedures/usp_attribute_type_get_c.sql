/*****************************************************************
**	Table Name: attribute_type
**	Procedure Name: usp_attribute_type_get_c
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_attribute_type_get_c]
	@attribute_type_code int
AS
SET NOCOUNT ON

SELECT [attribute_type_key], 
	[attribute_type_category], 
	[attribute_type_code], 
	[attribute_type_name], 
	[attribute_type_desc], 
	[attribute_data_type_key],
	[attribute_default_format],
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM attribute_type
WHERE [attribute_type_category] = @attribute_type_code


SET NOCOUNT OFF
