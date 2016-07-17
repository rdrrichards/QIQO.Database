CREATE TABLE [dbo].[company] (
    [company_key]           INT           DEFAULT (NEXT VALUE FOR [company_key_seq]) NOT NULL,
    [company_code]          VARCHAR (10)  NOT NULL,
    [company_name]          VARCHAR (50)  NOT NULL,
    [company_desc]          VARCHAR (255) NULL,
    [audit_add_user_id]     VARCHAR (30)  CONSTRAINT [DF__company__audit_a__5070F446] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME      CONSTRAINT [DF__company__audit_a__5165187F] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30)  CONSTRAINT [DF__company__audit_u__52593CB8] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME      CONSTRAINT [DF__company__audit_u__534D60F1] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__company__A2528AFF318AE843] PRIMARY KEY CLUSTERED ([company_key] ASC)
);


GO
CREATE TRIGGER [tgr_company_audit]
    ON [company]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [company] A INNER JOIN inserted B
		ON A.company_key = B.company_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [company] A INNER JOIN inserted B
		ON A.company_key = B.company_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [company] A INNER JOIN deleted B
		ON A.company_key = B.company_key
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
				   ,'company'
				   ,'company'
				   ,@old_xml
				   ,@new_xml)

    END




GO
CREATE TRIGGER [tgr_company_audit_del]
    ON [company]
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
				   ,'company'
				   ,'company record deleted'
				   ,@old_xml
				   )

    END



