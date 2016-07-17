CREATE TABLE [dbo].[attribute_type] (
    [attribute_type_key]       INT           CONSTRAINT [DF__attribute__attri__534D60F1] DEFAULT (NEXT VALUE FOR [attribute_type_key_seq]) NOT NULL,
    [attribute_type_category]  VARCHAR (50)  NOT NULL,
    [attribute_type_code]      VARCHAR (10)  NOT NULL,
    [attribute_type_name]      VARCHAR (50)  NOT NULL,
    [attribute_type_desc]      VARCHAR (150) NOT NULL,
    [attribute_data_type_key]  INT           CONSTRAINT [DF_attribute_type_attribute_data_type_key] DEFAULT ((2)) NOT NULL,
    [attribute_default_format] VARCHAR (150) CONSTRAINT [DF_attribute_type_attribute_default_format] DEFAULT ('') NOT NULL,
    [audit_add_user_id]        VARCHAR (30)  CONSTRAINT [DF__attribute__audit__33D4B598] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]       DATETIME      CONSTRAINT [DF__attribute__audit__34C8D9D1] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]     VARCHAR (30)  CONSTRAINT [DF__attribute__audit__35BCFE0A] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime]    DATETIME      CONSTRAINT [DF__attribute__audit__36B12243] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__attribut__B72A29F4FEEB245D] PRIMARY KEY CLUSTERED ([attribute_type_key] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20150721-150027]
    ON [dbo].[attribute_type]([attribute_type_category] ASC, [attribute_type_code] ASC, [attribute_type_name] ASC);


GO
CREATE TRIGGER [tgr_attribute_type_audit]
    ON [attribute_type]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [attribute_type] A INNER JOIN inserted B
		ON A.attribute_type_key = B.attribute_type_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [attribute_type] A INNER JOIN inserted B
		ON A.attribute_type_key = B.attribute_type_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [attribute_type] A INNER JOIN deleted B
		ON A.attribute_type_key = B.attribute_type_key
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
				   ,'attribute_type'
				   ,'attribute_type'
				   ,@old_xml
				   ,@new_xml)

    END


GO
CREATE TRIGGER [tgr_attribute_type_audit_del]
    ON [attribute_type]
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
				   ,'attribute_type'
				   ,'attribute_type record deleted'
				   ,@old_xml
				   )

    END

