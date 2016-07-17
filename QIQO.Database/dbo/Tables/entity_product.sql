CREATE TABLE [dbo].[entity_product] (
    [entity_product_key]    INT           DEFAULT (NEXT VALUE FOR [entity_product_key_seq]) NOT NULL,
    [product_key]           INT           NOT NULL,
    [product_type_key]      INT           NOT NULL,
    [entity_product_seq]    INT           DEFAULT ((1)) NOT NULL,
    [entity_key]            INT           NOT NULL,
    [entity_type_key]       INT           NOT NULL,
    [comment]               VARCHAR (150) NOT NULL,
    [audit_add_user_id]     VARCHAR (30)  DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME      DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30)  DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME      DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__entity_product__] PRIMARY KEY CLUSTERED ([entity_product_key] ASC),
    CONSTRAINT [FK_entity_product_product] FOREIGN KEY ([product_key]) REFERENCES [dbo].[product] ([product_key]),
    CONSTRAINT [FK_entity_product_product_type] FOREIGN KEY ([product_type_key]) REFERENCES [dbo].[product_type] ([product_type_key])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_entity_product]
    ON [dbo].[entity_product]([product_key] ASC, [product_type_key] ASC, [entity_product_seq] ASC, [entity_key] ASC, [entity_type_key] ASC);


GO
CREATE TRIGGER [tgr_entity_product_audit]
    ON [entity_product]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [entity_product] A INNER JOIN inserted B
		ON A.entity_product_key = B.entity_product_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [entity_product] A INNER JOIN inserted B
		ON A.entity_product_key = B.entity_product_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [entity_product] A INNER JOIN deleted B
		ON A.entity_product_key = B.entity_product_key
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
				   ,'entity_product'
				   ,'entity_product'
				   ,@old_xml
				   ,@new_xml)

    END




GO
CREATE TRIGGER [tgr_entity_product_audit_del]
    ON [entity_product]
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
				   ,'entity_product'
				   ,'entity_product record deleted'
				   ,@old_xml)

    END



