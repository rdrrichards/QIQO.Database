CREATE TABLE [dbo].[error_log] (
    [ErrorKey]       INT             DEFAULT (NEXT VALUE FOR [error_log_key_seq]) NOT NULL,
    [ErrorNumber]    INT             NULL,
    [ErrorSeverity]  INT             NULL,
    [ErrorState]     INT             NULL,
    [ErrorProcedure] NVARCHAR (128)  NULL,
    [ErrorLine]      INT             NULL,
    [ErrorMessage]   NVARCHAR (4000) NULL,
    [TableName]      NVARCHAR (128)  NULL,
    [ProcedureName]  NVARCHAR (128)  NULL,
    [ErrorDateTime]  DATETIME        CONSTRAINT [DF_error_log_ErrorDateTime] DEFAULT (getdate()) NOT NULL,
    [ProcedureStep]  NCHAR (1)       NULL,
    CONSTRAINT [PK_error_log] PRIMARY KEY CLUSTERED ([ErrorKey] ASC)
);

