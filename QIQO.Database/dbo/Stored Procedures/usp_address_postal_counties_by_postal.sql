/*****************************************************************
**	Table Name: address_postal
**	Procedure Name: usp_address_postal_counties_by_postal '37174'
**	Author: Richard Richards
**	Created: 08/16/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_address_postal_counties_by_postal]
	@postal_code varchar(20)
AS
SET NOCOUNT ON

SELECT DISTINCT [country], 
	[postal_code], 
	[state_code], 
	[state_full_name], 
	[city_name], 
	[county_name], 
	[time_zone] = 0
FROM address_postal
WHERE [postal_code] = @postal_code
AND [county_name] <> ''
ORDER BY [county_name]

SET NOCOUNT OFF


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_address_postal_counties_by_postal] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_address_postal_counties_by_postal] TO [businessuser]
    AS [dbo];

