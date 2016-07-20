CREATE PROCEDURE [dbo].[usp_get_next_order_num]
	@entity_key int
AS

DECLARE @curr_inv_num int, @new_inv_num int

BEGIN TRANSACTION
BEGIN
	SELECT @curr_inv_num = CONVERT(int, A.attribute_value)
	FROM attribute A WITH (ROWLOCK) INNER JOIN attribute_type B
	ON A.attribute_type_key = B.attribute_type_key
	WHERE A.entity_key = @entity_key
	AND A.entity_type_key = 3 -- account
	AND B.attribute_type_code = 'ORDNUM'

	-- SELECT @curr_inv_num
	SELECT @new_inv_num = @curr_inv_num + 1

	UPDATE A SET 
	A.attribute_value = CONVERT(varchar(max), @new_inv_num)
	FROM attribute A WITH (ROWLOCK) INNER JOIN attribute_type B
	ON A.attribute_type_key = B.attribute_type_key
	WHERE A.entity_key = @entity_key
	AND A.entity_type_key = 3 -- account
	AND B.attribute_type_code = 'ORDNUM'
END
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK
		EXEC dbo.usp_LogError 'attribute', 'usp_get_next_order_num', 'U'
		--RETURN -1
	END
	ELSE
		COMMIT

DECLARE @char_len int, @num_len int, @pat varchar(15), @acct_code varchar(30), @new_number varchar(15)

SELECT @char_len = LEN(attribute_value) - LEN(REPLACE(attribute_value, 'Z', '')),
	@num_len = LEN(REPLACE(attribute_value, 'Z', ''))-1, @pat = attribute_value, @acct_code = C.account_code
FROM attribute A WITH (ROWLOCK) INNER JOIN attribute_type B
ON A.attribute_type_key = B.attribute_type_key
INNER JOIN account C
ON A.entity_key = C.account_key
WHERE A.entity_key = @entity_key
AND A.entity_type_key = 3 -- account
AND B.attribute_type_code = 'ORDNUMPAT'

-- SELECT @char_len, @num_len, @pat, @acct_code

SELECT @new_number = REPLACE(REPLACE(@pat, REPLICATE('Z', @char_len), LEFT(@acct_code, @char_len)),
	REPLICATE('9', @num_len), RIGHT(REPLICATE('0', @num_len) + CONVERT(varchar(30), @new_inv_num), @num_len))

SELECT @new_number



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_get_next_order_num] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_get_next_order_num] TO [businessuser]
    AS [dbo];

