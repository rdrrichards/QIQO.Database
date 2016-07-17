CREATE TABLE [dbo].[audit_log] (
    [audit_log_key]         BIGINT        CONSTRAINT [DF__audit_log__audit__59FA5E80] DEFAULT (NEXT VALUE FOR [audit_log_key_seq]) NOT NULL,
    [audit_action]          CHAR (1)      NOT NULL,
    [audit_bus_obj]         VARCHAR (30)  NOT NULL,
    [audit_datetime]        DATETIME      DEFAULT (getdate()) NOT NULL,
    [audit_user_id]         VARCHAR (30)  DEFAULT (suser_sname()) NOT NULL,
    [audit_app_name]        VARCHAR (150) DEFAULT (('App=('+rtrim(isnull(app_name(),'')))+') ') NOT NULL,
    [audit_host_name]       VARCHAR (128) DEFAULT (host_name()) NOT NULL,
    [audit_comment]         VARCHAR (512) NULL,
    [audit_data_old]        XML           NULL,
    [audit_data_new]        XML           NULL,
    [audit_add_user_id]     VARCHAR (30)  DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME      DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30)  DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME      DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([audit_log_key] ASC) WITH (DATA_COMPRESSION = PAGE)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20150705-155746]
    ON [dbo].[audit_log]([audit_bus_obj] ASC);


GO

CREATE TRIGGER [tgr_audit_log_audit]
    ON [audit_log]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [audit_log] A INNER JOIN inserted B
		ON A.audit_log_key = B.audit_log_key

    END


