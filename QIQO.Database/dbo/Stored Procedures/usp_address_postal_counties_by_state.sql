/*****************************************************************
**	Table Name: address_postal
**	Procedure Name: usp_address_postal_counties_by_state 'TN'
**	Author: Richard Richards
**	Created: 08/16/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_address_postal_counties_by_state]
	@state_code varchar(50)
AS
SET NOCOUNT ON

SELECT DISTINCT [country], 
	[postal_code] = '', 
	[state_code], 
	[state_full_name], 
	[city_name] = '', 
	[county_name], 
	[time_zone] = 0
FROM address_postal
WHERE [state_code] = @state_code
AND [county_name] <> ''
ORDER BY [county_name]

SET NOCOUNT OFF


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_address_postal_counties_by_state] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_address_postal_counties_by_state] TO [businessuser]
    AS [dbo];

