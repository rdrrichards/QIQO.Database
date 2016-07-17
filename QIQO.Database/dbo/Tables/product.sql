CREATE TABLE [dbo].[product] (
    [product_key]           INT           DEFAULT (NEXT VALUE FOR [product_key_seq]) NOT NULL,
    [product_type_key]      INT           NOT NULL,
    [product_code]          VARCHAR (20)  NOT NULL,
    [product_name]          VARCHAR (150) NOT NULL,
    [product_desc]          VARCHAR (255) NULL,
    [product_name_short]    VARCHAR (50)  NOT NULL,
    [product_name_long]     VARCHAR (255) NOT NULL,
    [product_image_path]    VARCHAR (255) NOT NULL,
    [audit_add_user_id]     VARCHAR (30)  CONSTRAINT [DF__product__audit_a__7F2BE32F] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME      CONSTRAINT [DF__product__audit_a__00200768] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30)  CONSTRAINT [DF__product__audit_u__01142BA1] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME      CONSTRAINT [DF__product__audit_u__02084FDA] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__product__42799732195D12C1] PRIMARY KEY CLUSTERED ([product_key] ASC),
    CONSTRAINT [FK_product_product_type] FOREIGN KEY ([product_type_key]) REFERENCES [dbo].[product_type] ([product_type_key])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20150801-131647]
    ON [dbo].[product]([product_type_key] ASC, [product_code] ASC);


GO
CREATE TRIGGER [tgr_product_audit]
    ON [product]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [product] A INNER JOIN inserted B
		ON A.product_key = B.product_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [product] A INNER JOIN inserted B
		ON A.product_key = B.product_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [product] A INNER JOIN deleted B
		ON A.product_key = B.product_key
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
				   ,'product'
				   ,'product'
				   ,@old_xml
				   ,@new_xml)

    END




GO
CREATE TRIGGER [tgr_product_audit_del]
    ON [product]
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
				   ,'product'
				   ,'product record deleted'
				   ,@old_xml)

    END



