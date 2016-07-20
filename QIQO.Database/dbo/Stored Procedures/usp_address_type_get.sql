/*****************************************************************
**	Table Name: address_type
**	Procedure Name: usp_address_type_get
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_address_type_get]
	@address_type_key int
AS
SET NOCOUNT ON

SELECT [address_type_key], 
	[address_type_code], 
	[address_type_name], 
	[address_type_desc], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM address_type
WHERE [address_type_key] = @address_type_key


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_address_type_get] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_address_type_get] TO [businessuser]
    AS [dbo];

