CREATE PROCEDURE [dbo].[usp_get_next_vend_num]
	@entity_key int
AS

DECLARE @curr_vend_num int, @new_vend_num int

BEGIN TRANSACTION
BEGIN
	SELECT @curr_vend_num = CONVERT(int, A.attribute_value) -- SELECT *
	FROM attribute A WITH (ROWLOCK) INNER JOIN attribute_type B
	ON A.attribute_type_key = B.attribute_type_key
	WHERE A.entity_key = @entity_key
	AND A.entity_type_key = 1 -- company
	AND B.attribute_type_code = 'VENDORNUM'

	-- SELECT @curr_vend_num
	SELECT @new_vend_num = @curr_vend_num + 1

	UPDATE A SET 
	A.attribute_value = CONVERT(varchar(max), @new_vend_num)
	FROM attribute A WITH (ROWLOCK) INNER JOIN attribute_type B
	ON A.attribute_type_key = B.attribute_type_key
	WHERE A.entity_key = @entity_key
	AND A.entity_type_key = 1 -- company
	AND B.attribute_type_code = 'VENDORNUM'
END
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK
		EXEC dbo.usp_LogError 'attribute', 'usp_get_next_vend_num', 'U'
		--RETURN -1
	END
	ELSE
		COMMIT

DECLARE @char_len int, @pat varchar(15), @new_number varchar(15)

SELECT @char_len = LEN(attribute_value) - LEN(REPLACE(attribute_value, '9', '')),
	@pat = attribute_value -- SELECT *
FROM attribute A WITH (ROWLOCK) INNER JOIN attribute_type B
ON A.attribute_type_key = B.attribute_type_key
INNER JOIN account C
ON A.entity_key = C.account_key
WHERE A.entity_key = 1 -- @entity_key
AND A.entity_type_key = 1 -- company
AND B.attribute_type_code = 'VENDORNUMP'

-- SELECT @char_len, @pat, @new_vend_num

SELECT @new_number = RIGHT(REPLICATE('0', @char_len) + CONVERT(varchar(30), @new_vend_num), @char_len)

SELECT @new_number

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_get_next_vend_num] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_get_next_vend_num] TO [businessuser]
    AS [dbo];

