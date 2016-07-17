



/*****************************************************************
**	Table Name: address
**	Procedure Name: usp_address_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_address_ups]

	@address_key int,
	@address_type_key int,
	@entity_key int,
	@entity_type_key int,
	@address_line_1 varchar(75),
	@address_line_2 varchar(75),
	@address_line_3 varchar(75),
	@address_line_4 varchar(75),
	@address_city varchar(75),
	@address_state_prov varchar(5),
	@address_county varchar(50),
	@address_country varchar(50),
	@address_postal_code varchar(20),
	@address_notes varchar(150),
	@address_default_flg bit,
	@address_active_flg bit,
	@key int out
AS
SET NOCOUNT ON
IF @address_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR address_key_seq;
	INSERT INTO address ([address_key],
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
		[address_default_flg],
		[address_active_flg]
	)
	VALUES (@new_key,
		@address_type_key,
		@entity_key,
		@entity_type_key,
		@address_line_1,
		@address_line_2,
		@address_line_3,
		@address_line_4,
		@address_city,
		@address_state_prov,
		@address_county,
		@address_country,
		@address_postal_code,
		@address_notes,
		@address_default_flg,
		@address_active_flg
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'address', 'usp_address_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE address SET 
		[address_type_key] = @address_type_key,
		[entity_key] = @entity_key,
		[entity_type_key] = @entity_type_key,
		[address_line_1] = @address_line_1,
		[address_line_2] = @address_line_2,
		[address_line_3] = @address_line_3,
		[address_line_4] = @address_line_4,
		[address_city] = @address_city,
		[address_state_prov] = @address_state_prov,
		[address_county] = @address_county,
		[address_country] = @address_country,
		[address_postal_code] = @address_postal_code,
		[address_notes] = @address_notes,
		[address_default_flg] = @address_default_flg,
		[address_active_flg] = @address_active_flg
	WHERE [address_key] = @address_key
		AND ([address_type_key] <> @address_type_key
		OR [entity_key] <> @entity_key
		OR [entity_type_key] <> @entity_type_key
		OR [address_line_1] <> @address_line_1
		OR [address_line_2] <> @address_line_2
		OR [address_line_3] <> @address_line_3
		OR [address_line_4] <> @address_line_4
		OR [address_city] <> @address_city
		OR [address_state_prov] <> @address_state_prov
		OR [address_county] <> @address_county
		OR [address_country] <> @address_country
		OR [address_postal_code] <> @address_postal_code
		OR [address_notes] <> @address_notes
		OR [address_default_flg] <> @address_default_flg
		OR [address_active_flg] <> @address_active_flg);
	SELECT @key = @address_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'address', 'usp_address_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF






