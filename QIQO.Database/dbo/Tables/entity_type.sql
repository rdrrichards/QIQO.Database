CREATE TABLE [dbo].[entity_type] (
    [entity_type_key]       INT          DEFAULT (NEXT VALUE FOR [entity_type_key_seq]) NOT NULL,
    [entity_type_code]      VARCHAR (10) NOT NULL,
    [entity_type_name]      VARCHAR (50) NOT NULL,
    [audit_add_user_id]     VARCHAR (30) CONSTRAINT [DF__entity_ty__audit__737017C0] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME     CONSTRAINT [DF__entity_ty__audit__74643BF9] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30) CONSTRAINT [DF__entity_ty__audit__75586032] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME     CONSTRAINT [DF__entity_ty__audit__764C846B] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_entity_type] PRIMARY KEY CLUSTERED ([entity_type_key] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_entity_type]
    ON [dbo].[entity_type]([entity_type_key] ASC);


GO


CREATE TRIGGER [tgr_entity_type_audit]
    ON [entity_type]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [entity_type] A INNER JOIN inserted B
		ON A.entity_type_key = B.entity_type_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [entity_type] A INNER JOIN inserted B
		ON A.entity_type_key = B.entity_type_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [entity_type] A INNER JOIN deleted B
		ON A.entity_type_key = B.entity_type_key
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
				   ,'entity_type'
				   ,'entity_type'
				   ,@old_xml
				   ,@new_xml)

    END





GO


CREATE TRIGGER [tgr_entity_type_audit_del]
    ON [entity_type]
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
				   ,'entity_type'
				   ,'entity_type record deleted'
				   ,@old_xml)

    END




