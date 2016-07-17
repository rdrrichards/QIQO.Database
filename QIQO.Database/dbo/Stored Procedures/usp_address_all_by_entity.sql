/*****************************************************************
**	Table Name: address
**	Procedure Name: usp_address_all_by_entity
**	Author: Richard Richards
**	Created: 07/05/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_address_all_by_entity]
	@entity_key int,
	@entity_type_key int
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
FROM [address]
WHERE entity_key = @entity_key
AND entity_type_key = @entity_type_key

SET NOCOUNT OFF


