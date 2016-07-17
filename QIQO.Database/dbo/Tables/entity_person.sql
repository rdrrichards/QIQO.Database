CREATE TABLE [dbo].[entity_person] (
    [entity_person_key]     INT           CONSTRAINT [DF__entity_pe__entit__114A936A] DEFAULT (NEXT VALUE FOR [entity_person_key_seq]) NOT NULL,
    [person_key]            INT           NOT NULL,
    [person_type_key]       INT           NOT NULL,
    [entity_person_seq]     INT           CONSTRAINT [DF_entity_person_entity_person_seq] DEFAULT ((1)) NOT NULL,
    [person_role]           VARCHAR (50)  NULL,
    [entity_key]            INT           NOT NULL,
    [entity_type_key]       INT           NOT NULL,
    [comment]               VARCHAR (150) NOT NULL,
    [start_date]            DATETIME      CONSTRAINT [DF_entity_person_start_date] DEFAULT (getdate()) NOT NULL,
    [end_date]              DATETIME      CONSTRAINT [DF_entity_person_end_date] DEFAULT (dateadd(year,(25),getdate())) NOT NULL,
    [audit_add_user_id]     VARCHAR (30)  CONSTRAINT [DF__entity_pe__audit__13BCEBC1] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME      CONSTRAINT [DF__entity_pe__audit__14B10FFA] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30)  CONSTRAINT [DF__entity_pe__audit__15A53433] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME      CONSTRAINT [DF__entity_pe__audit__1699586C] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__entity_p__0DD67CD47D8BEE12] PRIMARY KEY CLUSTERED ([entity_person_key] ASC),
    CONSTRAINT [FK_entity_person_person] FOREIGN KEY ([person_key]) REFERENCES [dbo].[person] ([person_key]),
    CONSTRAINT [FK_entity_person_person_type] FOREIGN KEY ([person_type_key]) REFERENCES [dbo].[person_type] ([person_type_key])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20150701-155340]
    ON [dbo].[entity_person]([person_key] ASC, [person_type_key] ASC, [entity_person_seq] ASC, [entity_key] ASC, [entity_type_key] ASC);


GO
CREATE TRIGGER [tgr_entity_person_audit]
    ON [entity_person]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [entity_person] A INNER JOIN inserted B
		ON A.entity_person_key = B.entity_person_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [entity_person] A INNER JOIN inserted B
		ON A.entity_person_key = B.entity_person_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [entity_person] A INNER JOIN deleted B
		ON A.entity_person_key = B.entity_person_key
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
				   ,'entity_person'
				   ,'entity_person'
				   ,@old_xml
				   ,@new_xml)

    END


GO
CREATE TRIGGER [tgr_entity_person_audit_del]
    ON [entity_person]
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
				   ,'entity_person'
				   ,'entity_person record deleted'
				   ,@old_xml
				   )

    END

