CREATE TABLE [dbo].[product_type] (
    [product_type_key]      INT           DEFAULT (NEXT VALUE FOR [product_type_key_seq]) NOT NULL,
    [product_type_category] VARCHAR (50)  NOT NULL,
    [product_type_code]     VARCHAR (10)  NOT NULL,
    [product_type_name]     VARCHAR (50)  NOT NULL,
    [product_type_desc]     VARCHAR (150) NOT NULL,
    [audit_add_user_id]     VARCHAR (30)  CONSTRAINT [DF__product_t__audit__787EE5A0] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME      CONSTRAINT [DF__product_t__audit__797309D9] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30)  CONSTRAINT [DF__product_t__audit__7A672E12] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME      CONSTRAINT [DF__product_t__audit__7B5B524B] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__product___0C3CB02E882C396C] PRIMARY KEY CLUSTERED ([product_type_key] ASC)
);


GO
CREATE TRIGGER [tgr_product_type_audit]
    ON [product_type]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [product_type] A INNER JOIN inserted B
		ON A.product_type_key = B.product_type_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [product_type] A INNER JOIN inserted B
		ON A.product_type_key = B.product_type_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [product_type] A INNER JOIN deleted B
		ON A.product_type_key = B.product_type_key
		FOR XML RAW, ELEMENTS)

		IF (@new_xml IS NOT NULL OR @old_xml IS NOT NULL)
		INSERT INTO [dbo].[audit_log]
				   ([audit_action]
				   ,[audit_bus_obj]
				   ,[audit_comment]
				   ,[audit_data_old]
				   ,[audit_data_new])
			 VALUES
				   (CASE -- WHEN @old_xml IS NULL AND @new_xml IS NULL THEN 'D' 
						WHEN @old_xml IS NULL AND @new_xml IS NOT NULL THEN 'I'
						ELSE 'U' END
				   ,'product_type'
				   ,'product_type'
				   ,@old_xml
				   ,@new_xml)

    END




GO
CREATE TRIGGER [tgr_product_type_audit_del]
    ON [product_type]
    AFTER DELETE
    AS
    BEGIN
        SET NOCOUNT ON
		DECLARE @old_xml XML
		SELECT @old_xml = (SELECT B.* 
		FROM deleted B
		FOR XML RAW, ELEMENTS)

		IF (@old_xml IS NOT NULL)
		INSERT INTO [dbo].[audit_log]
				   ([audit_action]
				   ,[audit_bus_obj]
				   ,[audit_comment]
				   ,[audit_data_old]
				   )
			 VALUES
				   ('D' 
				   ,'product_type'
				   ,'product_type record deleted'
				   ,@old_xml)

    END



