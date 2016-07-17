CREATE TABLE [dbo].[person] (
    [person_key]            INT          DEFAULT (NEXT VALUE FOR [person_key_seq]) NOT NULL,
    [person_code]           VARCHAR (50) NOT NULL,
    [person_first_name]     VARCHAR (50) NOT NULL,
    [person_mi]             CHAR (1)     NULL,
    [person_last_name]      VARCHAR (50) NOT NULL,
    [parent_person_key]     INT          NULL,
    [person_dob]            DATE         NULL,
    [audit_add_user_id]     VARCHAR (30) CONSTRAINT [DF__person__audit_ad__056ECC6A] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME     CONSTRAINT [DF__person__audit_ad__0662F0A3] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30) CONSTRAINT [DF__person__audit_up__075714DC] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME     CONSTRAINT [DF__person__audit_up__084B3915] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__person__08E9D166D2A1B533] PRIMARY KEY CLUSTERED ([person_key] ASC)
);


GO
CREATE TRIGGER [tgr_person_audit]
    ON [person]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [person] A INNER JOIN inserted B
		ON A.person_key = B.person_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [person] A INNER JOIN inserted B
		ON A.person_key = B.person_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [person] A INNER JOIN deleted B
		ON A.person_key = B.person_key
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
				   ,'person'
				   ,'person'
				   ,@old_xml
				   ,@new_xml)

    END




GO
CREATE TRIGGER [tgr_person_audit_del]
    ON [person]
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
				   ,'person'
				   ,'person record deleted'
				   ,@old_xml)

    END



