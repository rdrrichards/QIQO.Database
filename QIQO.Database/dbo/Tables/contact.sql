CREATE TABLE [dbo].[contact] (
    [contact_key]           INT           DEFAULT (NEXT VALUE FOR [contact_key_seq]) NOT NULL,
    [entity_key]            INT           NOT NULL,
    [entity_type_key]       INT           NOT NULL,
    [contact_type_key]      INT           NOT NULL,
    [contact_value]         VARCHAR (150) NOT NULL,
    [contact_default_flg]   BIT           CONSTRAINT [DF_contact_contact_default_flg] DEFAULT ((0)) NOT NULL,
    [contact_active_flg]    BIT           CONSTRAINT [DF_contact_contact_active_flg] DEFAULT ((1)) NOT NULL,
    [audit_add_user_id]     VARCHAR (30)  CONSTRAINT [DF__contact__audit_a__571DF1D5] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME      CONSTRAINT [DF__contact__audit_a__5812160E] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30)  CONSTRAINT [DF__contact__audit_u__59063A47] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME      CONSTRAINT [DF__contact__audit_u__59FA5E80] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__contact__B9E5E4AED9EC076B] PRIMARY KEY CLUSTERED ([contact_key] ASC),
    CONSTRAINT [FK_contact_contact_type] FOREIGN KEY ([contact_type_key]) REFERENCES [dbo].[contact_type] ([contact_type_key]),
    CONSTRAINT [FK_contact_entity_type] FOREIGN KEY ([entity_type_key]) REFERENCES [dbo].[entity_type] ([entity_type_key])
);


GO
CREATE TRIGGER [tgr_contact_audit_del]
    ON [contact]
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
				   ,'contact'
				   ,'contact record deleted'
				   ,@old_xml
				   )

    END




GO
CREATE TRIGGER [tgr_contact_audit]
    ON [contact]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [contact] A INNER JOIN inserted B
		ON A.contact_key = B.contact_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [contact] A INNER JOIN inserted B
		ON A.contact_key = B.contact_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [contact] A INNER JOIN deleted B
		ON A.contact_key = B.contact_key
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
				   ,'contact'
				   ,'contact'
				   ,@old_xml
				   ,@new_xml)

    END



