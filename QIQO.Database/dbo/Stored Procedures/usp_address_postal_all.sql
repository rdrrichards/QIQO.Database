/*****************************************************************
**	Table Name: address_postal
**	Procedure Name: usp_address_postal_all
**	Author: Richard Richards
**	Created: 08/16/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_address_postal_all]
AS
SET NOCOUNT ON

SELECT [country], 
	[postal_code], 
	[state_code], 
	[state_full_name], 
	[city_name], 
	[county_name], 
	[time_zone]
FROM address_postal


SET NOCOUNT OFF

