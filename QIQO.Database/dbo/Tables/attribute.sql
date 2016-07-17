CREATE TABLE [dbo].[attribute] (
    [attribute_key]            INT           DEFAULT (NEXT VALUE FOR [attribute_key_seq]) NOT NULL,
    [entity_key]               INT           NOT NULL,
    [entity_type_key]          INT           NOT NULL,
    [attribute_type_key]       INT           NOT NULL,
    [attribute_value]          VARCHAR (MAX) NOT NULL,
    [attribute_data_type_key]  INT           NOT NULL,
    [attribute_display_format] VARCHAR (50)  NOT NULL,
    [audit_add_user_id]        VARCHAR (30)  CONSTRAINT [DF__attribute__audit__49C3F6B7] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]       DATETIME      CONSTRAINT [DF__attribute__audit__4AB81AF0] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]     VARCHAR (30)  CONSTRAINT [DF__attribute__audit__4BAC3F29] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime]    DATETIME      CONSTRAINT [DF__attribute__audit__4CA06362] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__attribut__2D9F97ADF3F6E466] PRIMARY KEY CLUSTERED ([attribute_key] ASC),
    CONSTRAINT [FK_attribute_attribute_type] FOREIGN KEY ([attribute_type_key]) REFERENCES [dbo].[attribute_type] ([attribute_type_key]),
    CONSTRAINT [FK_attribute_entity_type] FOREIGN KEY ([entity_type_key]) REFERENCES [dbo].[entity_type] ([entity_type_key])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_attribute_entity_key_entity_type_key_attribute_type_key]
    ON [dbo].[attribute]([entity_key] ASC, [entity_type_key] ASC, [attribute_type_key] ASC);


GO
CREATE TRIGGER [tgr_attribute_audit]
    ON [attribute]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [attribute] A INNER JOIN inserted B
		ON A.attribute_key = B.attribute_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [attribute] A INNER JOIN inserted B
		ON A.attribute_key = B.attribute_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [attribute] A INNER JOIN deleted B
		ON A.attribute_key = B.attribute_key
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
				   ,'attribute'
				   ,'attribute'
				   ,@old_xml
				   ,@new_xml)

    END




GO
CREATE TRIGGER [tgr_attribute_audit_del]
    ON [attribute]
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
				   ,'attribute'
				   ,'attribute record deleted'
				   ,@old_xml
				   )

    END



