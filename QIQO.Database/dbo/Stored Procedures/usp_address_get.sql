/*****************************************************************
**	Table Name: address
**	Procedure Name: usp_address_get
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_address_get]
	@address_key int
AS
SET NOCOUNT ON

SELECT [address_key], 
	[address_type_key], 
	[entity_key], 
	[entity_type_key], 
	[address_line_1], 
	[address_line_2], 
	[address_line_3], 
	[address_line_4], 
	[address_city], 
	[address_state_prov], 
	[address_county], 
	[address_country], 
	[address_postal_code], 
	[address_notes], 
	CAST([address_default_flg] AS int) AS [address_default_flg], 
	CAST([address_active_flg] AS int) AS [address_active_flg], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM address
WHERE [address_key] = @address_key


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_address_get] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_address_get] TO [businessuser]
    AS [dbo];

