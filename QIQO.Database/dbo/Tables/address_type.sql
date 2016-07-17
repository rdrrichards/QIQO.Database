CREATE TABLE [dbo].[address_type] (
    [address_type_key]      INT           CONSTRAINT [DF__address_t__addre__45F365D3] DEFAULT (NEXT VALUE FOR [address_type_key_seq]) NOT NULL,
    [address_type_code]     VARCHAR (10)  NOT NULL,
    [address_type_name]     VARCHAR (50)  NOT NULL,
    [address_type_desc]     VARCHAR (150) NOT NULL,
    [audit_add_user_id]     VARCHAR (30)  CONSTRAINT [DF__address_t__audit__3C69FB99] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME      CONSTRAINT [DF__address_t__audit__3D5E1FD2] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30)  CONSTRAINT [DF__address_t__audit__3E52440B] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME      CONSTRAINT [DF__address_t__audit__3F466844] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__address___3D1E2C82810DB750] PRIMARY KEY CLUSTERED ([address_type_key] ASC)
);


GO
CREATE TRIGGER [tgr_address_type_audit]
    ON [address_type]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [address_type] A INNER JOIN inserted B
		ON A.address_type_key = B.address_type_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [address_type] A INNER JOIN inserted B
		ON A.address_type_key = B.address_type_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [address_type] A INNER JOIN deleted B
		ON A.address_type_key = B.address_type_key
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
				   ,'address_type'
				   ,'address_type'
				   ,@old_xml
				   ,@new_xml)

    END




GO
CREATE TRIGGER [tgr_address_type_audit_del]
    ON [address_type]
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
				   ,'address_type'
				   ,'address_type record deleted'
				   ,@old_xml
				   )

    END



