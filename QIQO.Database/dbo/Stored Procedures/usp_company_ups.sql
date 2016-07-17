



/*****************************************************************
**	Table Name: company
**	Procedure Name: usp_company_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_company_ups]

	@company_key int,
	@company_code varchar(10),
	@company_name varchar(50),
	@company_desc varchar(255),
	@key int out
AS
--SET NOCOUNT ON
IF @company_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR company_key_seq;
	INSERT INTO company ([company_key],
		[company_code],
		[company_name],
		[company_desc]
	)
	VALUES (@new_key,
		@company_code,
		@company_name,
		@company_desc
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'company', 'usp_company_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE company SET 
		[company_code] = @company_code,
		[company_name] = @company_name,
		[company_desc] = @company_desc
	WHERE [company_key] = @company_key
		AND ([company_code] <> @company_code
		OR [company_name] <> @company_name
		OR [company_desc] <> @company_desc);
	SELECT @key = @company_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'company', 'usp_company_ups', 'U';
		THROW;
	END CATCH
END

--SET NOCOUNT OFF






